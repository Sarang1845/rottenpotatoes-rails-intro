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
    @movies = Movie.all
    @all_ratings = Movie.allratings
    if (params[:sort_using].present?)
      session[:sort_using] = params[:sort_using] #remember if sorting settings explicitly specified
    else
      params[:sort_using] = session[:sort_using] #assign stored sorting settings to current settings
    end
    if (params[:ratings].present?) 
      session[:ratings] = params[:ratings] #remember if filter settings explicitly specified
    else
      params[:ratings] = session[:ratings] #assign stored filter settings to current settings
    end
    
    if session[:ratings].present?
      @checked = session[:ratings].keys
    end
    if @checked.present?
      @movies = Movie.all.where(rating: @checked)
    end
    if session[:sort_using] == 'title'
      @movies = @movies.order(:title)
      @flag1 = 'hilite' # set the CSS class of the 'Movie Title' heading to hilite only if the Movie Title link is clicked
    elsif session[:sort_using] == 'release_date'
      @movies = @movies.order(:release_date) # set the CSS class of the 'Release Date' heading to hilite only if the 	Release Date heading link is clicked
      @flag2 = 'hilite'
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
