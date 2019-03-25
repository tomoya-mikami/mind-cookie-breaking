require 'rmagick'
require 'csv'
require 'fileutils'
require 'httpclient'
require 'uri'
require 'json'
require 'socket'

namespace :setup do
  desc "ディレクトリの初期化"
  task :dir, ['token'] => :environment do |task, args|
    if ! args['token']
      puts 'プロジェクトのトークンを入力してください'
      next
    end

    project = Project.find_by(token: args['token'])
    if ! project
      puts 'プロジェクトが見つかりません'
      next
    end

    paths = []
    image_path = Rails.public_path.join('img', project.name).to_s
    paths << image_path + '/src'
    paths << image_path + '/dest'
    paths << image_path + '/original'

    begin
      paths.each do |path|
        FileUtils.mkdir_p(path) unless FileTest.exist?(path)
      end
    rescue => exception
      Rails.logger.error("ディレクトリの作成に失敗しました: #{exception}")
      puts 'ディレクトリの作成に失敗しました'
      next
    end
      
    puts 'ディレクトリの作成に成功しました'
  end

  desc "画像の初期化"
  task :image, ['token'] => :environment do |task, args|
    if ! args['token']
      puts 'プロジェクトのトークンを入力してください'
      next
    end

    project = Project.find_by(token: args['token'])
    if ! project
      puts 'プロジェクトが見つかりません'
      next
    end

    project_path = Rails.public_path.join('img', project.name).to_s
    original_dir = project_path + '/original'
    src_dir =  project_path + '/src'
    output_dir = project_path + '/dest'

    src_files = []
    num = 0

    dest_image = nil
    image = nil

    src_files = []
    num = 0

    client = HTTPClient.new()
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE

    sources = []

    begin
      FileUtils.rm_r(output_dir)
      FileUtils.mkdir_p(output_dir)
      FileUtils.rm_r(src_dir)
      FileUtils.mkdir_p(src_dir)

      originals = Dir.glob(original_dir + '/*')
      originals.each do |original|
        filename = File.basename(original)
        name, ext = /\A(.+?)((?:\.[^.]+)?)\z/.match(filename, &:captures)
        image = Magick::ImageList.new(original_dir + '/' + filename)
        image.write(src_dir + '/' + name + '.png')
        dest_image = image.resize_to_fit(500, 500)
        dest_image.write(output_dir + '/' + name + '_1_1_1.png')
        num = num + 1
        src_files.push([num, src_dir + '/' + name + '.png'])
        dest_image.destroy!
        image.destroy!
        source = project.sources.build(name: name, uuid: SecureRandom.uuid)
        image_path = Settings.url + '/img/' + project.name + '/dest/' + source.name + '_1_1_1.png'
        tuple = "source_id:#{source.uuid},image_url:#{image_path},status_id:-1"
        res = client.post(project.estimate_url, 
          {
            :project_name => project.name,
            :relation_name => "Image",
            :tuple => tuple
          }
        )
        sources << source
      end

      puts '画像の準備に成功しました'

    rescue => exception
      dest_image.destroy! if dest_image
      image.destroy! if image
      Rails.logger.error("画像の準備に失敗しました: #{exception}")
    end

    Source.import sources
  end
end

