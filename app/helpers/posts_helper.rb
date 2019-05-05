module PostsHelper
  def btn_class(type = 'Exercise')
    case type
    when 'Diet'
      'btn-success'
    when 'App'
      'btn-info'
    else
      'btn-danger'
    end
  end
end
