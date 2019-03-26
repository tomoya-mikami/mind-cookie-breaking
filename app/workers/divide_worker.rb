class DivideWorker
  include Sidekiq::Worker

  def perform(basefile, base_depth, base_vertical, base_horizontal, column, row, source_id, url, project_name)
    project_path = Rails.public_path.join('img', project_name).to_s
    src_dir =  project_path + '/src'
    output_dir = project_path + '/dest'
    extension = 'png'
    divid = 2 ** base_depth.to_i

    src = nil
    image = nil

    client = HTTPClient.new()
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE

    begin
      src = Magick::ImageList.new("#{src_dir}/#{basefile}.#{extension}")

      width = src.columns / divid
      height = src.rows / divid

      (1..row).each do |i|
        (1..column).each do |j|
          output_vertical = 2 * base_vertical.to_i + j - 2
          output_horizontal = 2 * base_horizontal.to_i + i - 2
          output_depth = base_depth.to_i + 1
          output_file = "#{output_dir}/#{basefile}_#{output_depth}_#{output_vertical}_#{output_horizontal}.#{extension}"
          next if File.exist?(output_file)
          image = src.crop(width * (output_horizontal - 1), height * (output_vertical - 1), width, height, true)
          dest_image = image.resize_to_fit(500, 500)
          dest_image.write(output_file)
          dest_image.destroy!
          image.destroy!
          image_path = Settings.url + '/img/' + project_name + '/dest/' + "#{basefile}_#{output_depth}_#{output_vertical}_#{output_horizontal}.#{extension}"
          tuple = "source_id:#{source_id},image_url:#{image_path},status_id:-1"
          #res = client.post(url, 
          #  {
          #    :project_name => project_name,
          #    :relation_name => "Image",
          #    :tuple => tuple
          #  }
          #)
        end
      end
      src.destroy!

      logger.info "画像の分割に成功しました basefile : #{basefile}"

    rescue => error
      src.destroy! if src
      image.destroy! if image
      logger.error "画像の分割に失敗しました basefile : #{basefile}"
      logger.error "error : #{error}"
    end
  end
end
