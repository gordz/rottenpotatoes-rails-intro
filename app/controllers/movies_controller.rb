class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "params[:ratings]: #{params[:ratings]}"
    puts "params[:orderBy]: #{params[:orderBy]}"
    puts "session[:ratings]: #{session[:ratings]}"
    puts "session[:orderBy]: #{session[:orderBy]}"

    orderBy = params[:orderBy]
    if orderBy != nil
      session[:orderBy] = orderBy
    end

    ratings = params[:ratings]
    if ratings != nil
      session[:ratings] = ratings
    end

    redirect_params = {}
    if params[:orderBy] != session[:orderBy] || params[:ratings] != session[:ratings]
      redirect_params = redirect_params.merge({:orderBy => session[:orderBy], :ratings => session[:ratings]})
      redirect_to movies_path(redirect_params)
    else
        #if (orderBy != nil && params[:orderBy] == nil) || (ratings != nil && params[:ratings] == nil)
        #  puts "Preparing to redirect"
       #   puts "merged hash: " + ({:orderBy => orderBy}.merge(ratings).keys.to_s)
       #   redirect_to movies_path({:orderBy => orderBy}.merge(ratings))
       # end

      if ratings == nil || ratings == {}
        if orderBy != nil
          @movies = Movie.order(orderBy)
        else
          @movies = Movie.all
        end
      else
        @selected_ratings = ratings
        if orderBy != nil
          @movies = Movie.where(rating: ratings.keys).order(orderBy)
        else
          @movies = Movie.where(rating: ratings.keys)
        end
      end

      @orderBy = orderBy

      @all_ratings = Movie.ratings
      if ratings == nil
        ratings = {}
      end
      @ratings = ratings
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
