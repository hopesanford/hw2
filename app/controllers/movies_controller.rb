class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  @all_ratings = Movie.all_ratings
  if !session.has_key?(:ratings)
    session[:ratings] = {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
  else
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    end
  end
  if params.has_key?(:order)
    session[:order] = params[:order]
  end
  if !params.has_key?(:ratings)
    params[:ratings] = session[:ratings]
  end
  @movies = Movie.order(session[:order])
  @movies = @movies.find_all_by_rating(session[:ratings].keys)
 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
