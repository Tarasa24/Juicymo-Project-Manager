def test_not_logged_in(path, user, method = 'get')
  sign_out user

  case method
  when 'get'
    get path
  when 'post'
    post path
  when 'put'
    put path
  when 'delete'
    delete path
  end
  expect(response).to redirect_to(new_user_session_path)
end