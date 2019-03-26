class DivideController < ApplicationController

  before_action :project_check

  def index

    params_check
    if @response['error']
      return render :json => @response
    end

    basefile = params['basefile']
    base_depth = params['base_depth']
    base_vertical = params['base_vertical']
    base_horizontal = params['base_horizontal']
    column = params['column'].to_i
    row = params['row'].to_i
    source_id = params['source_id']

    # 即時実行
    DivideWorker.perform_async(basefile, base_depth, base_vertical, base_horizontal, column, row, source_id, @project.estimate_url, @project.name)

    @response['status'] = 200
    @response['message'] = '画像分割キューに入りました'
    render :json => @response
  end

  private

  def response_init
    response = {
      'error' => false,
      'message' => {},
      'status' => '',
      'results' => {}
    }
  end

  def project_check
    @response = response_init
    if ! params.has_key?(:project_token)
      @response['error'] = true
      @response['message']['error'] = ['プロジェクトのトークンを送ってください']
      @response['status'] = 500
    else
      begin
        @project = Project.find_by(token: params[:project_token])
        if ! @project
          @response['error'] = true
          @response['message']['error'] = ['プロジェクトが見つかりません']
          @response['status'] = 404
        end
      rescue => e
          @response['error'] = true
          @response['message']['error'] = ['致命的なエラーが発生しました']
          @response['message']['catch'] = e
          @response['status'] = 500
          logger.error "error: #{e}"
          logger.error "params: #{params.inspect}"
      end
    end

    if @response['error']
      return render :json => @response
    end
  end

  def params_check

    if ! params.has_key?(:basefile)
      @response['error'] = true
      @response['message']['not_found_basefile'] = ['basefileを指定してください']
    end

    if ! params.has_key?(:base_depth)
      @response['error'] = true
      @response['message']['not_found_base_depth'] = ['base_depthを指定してください']
    end

    if ! params.has_key?(:base_vertical)
      @response['error'] = true
      @response['message']['not_found_base_vertical'] = ['base_verticalを指定してください']
    end

    if ! params.has_key?(:base_horizontal)
      @response['error'] = true
      @response['message']['not_found_base_horizontal'] = ['base_horizontalを指定してください']
    end

    if ! params.has_key?(:column)
      @response['error'] = true
      @response['message']['not_found_column'] = ['columnを指定してください']
    end

    if ! params.has_key?(:row)
      @response['error'] = true
      @response['message']['not_found_row'] = ['rowを指定してください']
    end

    if ! params.has_key?(:source_id)
      @response['error'] = true
      @response['message']['not_found_source_id'] = ['source_idを指定してください']
    end

    if @response['error']
      @response['status'] = 500
    end

  end
end
