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
    orderBy = params[:orderBy] || session[:orderBy]
    ratings = params[:ratings] || session[:ratings]

    session[:ratings] = ratings
    session[:orderBy] = orderBy

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
