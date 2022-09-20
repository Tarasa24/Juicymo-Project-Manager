# frozen_string_literal: true


# Tests provided path with given method, in situation when user is not logged in.
# Expects to be redirected to login page.
# @param [String] path
# @param [User] user
# @param [String] method
def test_not_logged_in(path, user, method = "get")
  sign_out user

  case method
  when "get"
    get path
  when "post"
    post path
  when "put"
    put path
  when "delete"
    delete path
  else
    raise "Unknown method: #{method}"
  end

  expect(response).to redirect_to(new_user_session_path)
end
