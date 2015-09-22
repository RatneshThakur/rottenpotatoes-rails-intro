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
    @all_ratings = Movie.getRatings 
    @ratingsValues = @all_ratings 
    @sort = nil;
    if(params[:ratings] != nil )
      session[:ratings] = params[:ratings]
    end
    if(params[:sort] != nil)
      session[:sort] = params[:sort]
      @sort = params[:sort]
    elsif(session[:sort] != nil)
      @sort = session[:sort]
    end  
    if(params[:ratings] != nil)
      @ratingsValues = params[:ratings].keys    
    elsif(session[:ratings] != nil)
      @ratingsValues = session[:ratings].keys
    end

    if(params[:sort] != session[:sort] or params[:ratings] != session[:ratings])
      if(params[:ratings] == nil)
        redirect_to(:sort => @sort, :ratings => session[:ratings]) and return        
      else
        redirect_to(:sort =>@sort, :ratings => params[:ratings]) and return
        return;
      end
    end

    if(@sort == "title")      
      @movie_title_header = "hilite"      
      @movies = Movie.where("rating IN (?)", @ratingsValues).order("title")     
    elsif(@sort == "release_date")
      @release_date_header = "hilite"
      @movies = Movie.where("rating IN (?)", @ratingsValues).order("release_date")
    else
      @table_header = ""
      @movies = Movie.where("rating IN (?)", @ratingsValues)
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
