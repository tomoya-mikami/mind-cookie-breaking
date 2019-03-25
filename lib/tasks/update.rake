require 'httpclient'
require 'json'
require "uri"

namespace :update do
  def start_index(depth, vertical_index, horizontal_index, base_height, base_width, target_depth)
    if depth != target_depth then
      # 縦
      height_group_member_count = base_height * (target_depth - depth)
      vertical_start_index = 1 + (vertical_index - 1) * height_group_member_count;
      # 横
      width_group_member_count = base_width * (target_depth - depth)
      horizontal_start_index = 1 + (horizontal_index - 1) * width_group_member_count;
    else
      vertical_start_index = vertical_index
      horizontal_start_index = horizontal_index
    end

    # 配列のインデックスは0から
    return [vertical_start_index - 1, horizontal_start_index - 1]
  end

  def set_value(status_matrix, start_index, depth, base_height, base_width, target_depth, result_status)
    vertical_start_index = start_index[0]
    horizontal_start_index = start_index[1]
    if depth != target_depth then
      vertical_move_count = base_height * (target_depth - depth)
      horizontal_move_count = base_width * (target_depth - depth)
      for horizontal_index in 0..horizontal_move_count - 1
        for vertical_index in 0..vertical_move_count - 1
          status_matrix[vertical_start_index + vertical_index][horizontal_start_index + horizontal_index] = result_status
        end
      end
    else
      status_matrix[vertical_start_index][horizontal_start_index] = result_status
    end
    return status_matrix
  end


  desc "crowd4Uのタスク結果を反映する"
  task :sources => :environment do |task, args|

    client = HTTPClient.new()
    client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
    projects = Project.all
    update_sources = []

    projects.each do |project|
      res = ''
      width = 2
      height = 2

      begin
        res = client.get('https://crowd4u.org/api/relation_data', 
          {
            :project_name => project.name,
            :relation_name => "Image",
          }
        )
        raise "サーバー側でエラーが発生しました(500エラー)" if res.code == 500
      rescue => exception
        Rails.logger.error("プロジェクト[#{project.name}] プロジェクトの結果の取得に失敗しました: #{exception}")
        next
      end
      images = JSON::parse(res.body)

      project.sources.each do |source|
        results = {}
        images['data'].each do |image|
          if image['source_id'] == source.uuid
            basefile, base_depth, base_vertical, base_horizontal = /(.+?)_(\d+?)_(\d+?)_(\d+?)\..+/.match(File.basename(image['image_url']), &:captures)
            if ! results.key?(base_depth)
              results[base_depth] = []
            end
            results[base_depth].push({'vertical' => base_vertical, 'horizontal' => base_horizontal, 'status' => image['status_id']})
          end
        end

        if results.empty?
          next
        end

        target_depth = results.keys.max.to_i
        divid_width = width**(target_depth - 1)
        divid_height = height**(target_depth - 1)

        status_matrix = Array.new(divid_height).map{Array.new(divid_width, 0)}

        results.each do |depth, depth_results|
          depth_results.each do |result|
            status_matrix = set_value(status_matrix, start_index(depth.to_i, result['vertical'].to_i, result['horizontal'].to_i, height, width, target_depth), depth.to_i, height, width, target_depth, result['status'])
          end
        end

        source.status = status_matrix.to_json
        update_sources << source
      end
    end

    if ! update_sources.empty?
      begin
        Source.import update_sources, on_duplicate_key_update:[:status]
      rescue => exception
        Rails.logger.error("データベースの更新に失敗しました: #{exception}")
      end
    end

  end
end

