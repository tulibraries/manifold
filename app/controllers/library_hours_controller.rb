class LibraryHoursController < ApplicationController
  before_action :set_library_hour, only: [:show, :edit, :update, :destroy]

  # GET /library_hours
  # GET /library_hours.json
  def index
    @library_hours = LibraryHours.all
  end

  # GET /library_hours/1
  # GET /library_hours/1.json
  def show
  end

  # GET /library_hours/new
  def new
    @library_hour = LibraryHours.new
  end

  # GET /library_hours/1/edit
  def edit
  end

  # POST /library_hours
  # POST /library_hours.json
  def create
    @library_hour = LibraryHours.new(library_hour_params)

    respond_to do |format|
      if @library_hour.save
        format.html { redirect_to @library_hour, notice: 'Library hours was successfully created.' }
        format.json { render :show, status: :created, location: @library_hour }
      else
        format.html { render :new }
        format.json { render json: @library_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /library_hours/1
  # PATCH/PUT /library_hours/1.json
  def update
    respond_to do |format|
      if @library_hour.update(library_hour_params)
        format.html { redirect_to @library_hour, notice: 'Library hours was successfully updated.' }
        format.json { render :show, status: :ok, location: @library_hour }
      else
        format.html { render :edit }
        format.json { render json: @library_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /library_hours/1
  # DELETE /library_hours/1.json
  def destroy
    @library_hour.destroy
    respond_to do |format|
      format.html { redirect_to library_hours_index_url, notice: 'Library hours was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library_hour
      @library_hour = LibraryHours.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_hour_params
      params.require(:library_hour).permit(:location, :date, :hours)
    end
end
