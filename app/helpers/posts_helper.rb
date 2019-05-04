module PostsHelper
  def btn_class(type = 'Exercise')
    case type
    when 'Diet'
      'btn-success'
    else
      'btn-danger'
    end
  end
end
