module AuthHelper
    def http_login(request)
        user = "dhh"
        pw = "secret"
        if request
            request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
        end
    end
end