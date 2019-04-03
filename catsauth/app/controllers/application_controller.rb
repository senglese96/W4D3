class ApplicationController < ActionController::Base

    def not_loggedin
        if current_user
            redirect_to "/cats"
        end
    end

    def current_user
        @current_user = User.find_by(session_token: session[:session_token])
    end

    def login_user!(user)
        user.reset_session_token!
        session[:session_token] = user.session_token
    end


    helper_method :current_user, :login_user!
end
