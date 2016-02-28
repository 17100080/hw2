class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def to_delete
  end
  
  def deleting
   @vars=params[:movie]
   @t=@vars[:title]
   
   
    if (@t.length!=0)
            @movie=Movie.find_by(title: @vars[:title])
            if(@movie)
              @movie.destroy
              flash[:notice] = "movie with title #{@t} deleted"
            else
              flash[:notice] = "No movie match to delete"
            end
  
          
    elsif (@vars[:rating] != 'None')

          @mrating =  @vars[:rating]
          @selected = Movie.where('rating = ?',@mrating)
          @selected.each do |x|
            x.destroy
          end
          flash[:notice] = "All movies with rating #{@mrating} deleted"
    else
      flash[:notice] = "No movie match to delete"
      
    end
      redirect_to movies_path
     
  end
  
  def match_title
  end
  
  def updating
        @var = params[:movie]
        @movie = Movie.find_by(title: @var[:name])
     
      if (!(@movie))
          flash[:notice] = "Movie not found"
      else
          @mtitle =  @var[:title]
          @mrelease =  @var[:release_date]
          @mrating =  @var[:rating]
          if @mrating !='' && @mrelease !='' && @mtitle !=''
            @movie.update_attributes!(movie_params)
            flash[:notice] = "#{@movie.title} #{@movie.release_date} #{@movie.rating} was successfully updated."
          else
           flash[:notice] = "Nothing changed"
          end
      end
      redirect_to movies_path
    
  
  end



  def index
    if params[:sort_by_t]
      @movies = Movie.order(params[:sort_by_t]);@var1='hilite'
      
    elsif params[:sort_by_r]
      @movies=Movie.order(params[:sort_by_r]);@var2='hilite'
      
    else 
      @movies=Movie.all ;@var=''
      
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
