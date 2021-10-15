class GranteesController < ApplicationController
  before_action :set_grantee, only: %i[show edit update destroy]

  # GET /grantees or /grantees.json
  def index
    @grantees = Grantee.all
  end

  # GET /grantees/1 or /grantees/1.json
  def show
    render layout: "details"
  end

  # GET /grantees/new
  def new
    @grantee = Grantee.new
  end

  # GET /grantees/1/edit
  def edit
  end

  # POST /grantees or /grantees.json
  def create
    @grantee = Grantee.new(grantee_params)

    respond_to do |format|
      if @grantee.save
        format.html { redirect_to @grantee, notice: "Grantee was successfully created." }
        format.json { render :show, status: :created, location: @grantee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grantee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grantees/1 or /grantees/1.json
  def update
    respond_to do |format|
      if @grantee.update(grantee_params)
        format.html { redirect_to @grantee, notice: "Grantee was successfully updated." }
        format.json { render :show, status: :ok, location: @grantee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grantee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grantees/1 or /grantees/1.json
  def destroy
    @grantee.destroy
    respond_to do |format|
      format.html { redirect_to grantees_url, notice: "Grantee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grantee
    @grantee = Grantee.new(
      ApiDelegator.use("hses", "issue", {id: params[:id]}).request.data
    )
  end

  # Only allow a list of trusted parameters through.
  def grantee_params
    params.fetch(:grantee, {})
  end
end
