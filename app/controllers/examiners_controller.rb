class ExaminersController < ApplicationController
  def index
    @examiners = Examiner.all
  end 


  def show
    @examiner = Examiner.find(params[:id])
  end 

  def new
    @examiner = Examiner.new
  end 

  def edit
    @examiner = Examiner.find(params[:id])
  end 

  def create
    @examiner = Examiner.new(examiner_params)

    if @examiner.save
      redirect_to @examiner
    else
      render 'new'
    end
  end 

  def update
    @examiner = Examiner.find(params[:id])

    if @examiner.update(examiner_params)
      redirect_to @examiner
    else
      render 'edit'
    end
  end 

  def destroy
    @examiner = Examiner.find(params[:id])
    @examiner.destroy

    redirect_to examiners_path
  end
  

  private
  def examiner_params
    params.require(:examiner).permit(:name, :alterativeNames)
  end

end
