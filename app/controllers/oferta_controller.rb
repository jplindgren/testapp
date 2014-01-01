class OfertaController < ApplicationController
  # GET /oferta
  # GET /oferta.json
  def index
    @oferta = Ofertum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @oferta }
    end
  end

  # GET /oferta/1
  # GET /oferta/1.json
  def show
    @ofertum = Ofertum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ofertum }
    end
  end

  # GET /oferta/new
  # GET /oferta/new.json
  def new
    @ofertum = Ofertum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ofertum }
    end
  end

  # GET /oferta/1/edit
  def edit
    @ofertum = Ofertum.find(params[:id])
  end

  # POST /oferta
  # POST /oferta.json
  def create
    @ofertum = Ofertum.new(params[:ofertum])

    respond_to do |format|
      if @ofertum.save
        format.html { redirect_to @ofertum, notice: 'Ofertum was successfully created.' }
        format.json { render json: @ofertum, status: :created, location: @ofertum }
      else
        format.html { render action: "new" }
        format.json { render json: @ofertum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /oferta/1
  # PUT /oferta/1.json
  def update
    @ofertum = Ofertum.find(params[:id])

    respond_to do |format|
      if @ofertum.update_attributes(params[:ofertum])
        format.html { redirect_to @ofertum, notice: 'Ofertum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ofertum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /oferta/1
  # DELETE /oferta/1.json
  def destroy
    @ofertum = Ofertum.find(params[:id])
    @ofertum.destroy

    respond_to do |format|
      format.html { redirect_to oferta_url }
      format.json { head :no_content }
    end
  end
end
