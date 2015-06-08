module App
  class Server < Sinatra::Base

    # A session is used to keep state during requests.
    # http://www.sinatrarb.com/intro.html#Using%20Sessions
    enable :sessions

    # Use _method magic to allow put/delete forms in browsers that don't support it.
    enable :method_override # same as doing use Rack::MethodOverride

    $db = PG.connect({dbname: 'discussiondb'})

    configure :development do
      register Sinatra::Reloader
#---------****  *****----
      set :sessions, true
    end
    

#-------login current user----*****------
    def current_user
        session[:user_id]
    end
    
    def logged_in?
      !current_user.nil?
    end


    get('/') do
      erb :index
    end

    get('/login') do
      erb :login
    end

    post('/login') do
      email = params[:email]
      password = params[:password]

      query = "SELECT * FROM users WHERE email = $1 LIMIT 1"
      results = $db.exec_params(query, [email])
      user = results.first # if we don't find a matching user this is nil
      if user && user['password'] == password
        session[:user_id] = user['id'] # store the id in session to save it between requests
        redirect '/dashboard'
      else
        @message = 'incorrect email or password'
        erb :login
      end
    end

    get('/dashboard') do
      user_id = session[:user_id] # retrieve the stored user id
      if user_id
        query = "SELECT * FROM users WHERE id = $1 LIMIT 1"
        results = $db.exec_params(query, [user_id])

        @user = results.first
        erb :dashboard
      else
        redirect '/'
      end

    end

    delete('/logout') do
      session[:user_id] = nil
      redirect '/'
    end


#-----------------


    post '/addtopic' do 
          if logged_in? 
          result = $db.exec_params("INSERT INTO topicname (topic_name, user_id, created_at) VALUES ($1, $2, CURRENT_TIMESTAMP) RETURNING id", [params[:topicname],current_user])
          redirect("/addtopic/#{result.first["id"]}")
        else
          status 403
          "Permission Denied"
        end
    end


#------------
    get '/addtopic/:id' do
      "hello"
      topic = $db.exec_params("SELECT * FROM topicname WHERE id = $1", [params[:id]]).first["id"]
      @topics = $db.exec_params("SELECT topicname.*, users.name AS topiccreator, users.email AS contact FROM topicname JOIN users ON users.id = topicname.user_id WHERE topicname.id = $1", [topic])
      # @topics = $db.exec_params("SELECT topicname.*, users.name AS topiccreator, users.email AS contact FROM topicname JOIN users ON users.id = topicname.user_id WHERE topicname.id = $1", [topic]).first
      erb :collection
    end




    get '/commentsonthem' do 
      @topics = $db.exec_params("SELECT * from topicname")
      erb :allcomments
    end

    get '/commentsonthem/one' do 
      @topics = $db.exec_params("SELECT * from topicname")
      erb :allcomments
    end



  end #class
end #module


