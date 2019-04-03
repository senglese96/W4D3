class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        # debugger
        user = User.find_by_credentials(session_params["user_name"], session_params["password"])

        if user
            user.reset_session_token!
            session[:session_token] = user.session_token
            redirect_to "/cats"
        else
            render :new
        end
    end

    def destroy
        if current_user
            current_user.reset_session_token!
            session[:session_token] = nil
        end
    end

    private
    def session_params
        params.require(:user).permit(:user_name, :password)
    end
end
