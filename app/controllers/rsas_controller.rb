require 'prime'

class RsasController < ApplicationController
  before_action :set_rsa, only: [:show, :edit, :update, :destroy]
	protect_from_forgery with: :null_session

  # GET /rsas
  # GET /rsas.json
  def index
    @rsas = Rsa.all
  end

  # GET /rsas/1
  # GET /rsas/1.json
  def show
	rsa = Rsa.find_by id: params[:id]
	render json: {'n' => rsa.n, 'e' => rsa.e, 'd' => rsa.d }
  end

  # GET /rsas/new
  def new
    @rsa = Rsa.new
  end

  # GET /rsas/1/edit
  def edit
  end

  # POST /rsas
  # POST /rsas.json
  def create
	if(params.has_key?(:n) && params.has_key?(:e) && params.has_key?(:d))
		@rsa = Rsa.new({n: params[:n], e: params[:e], d: params[:d]})
	else
		keys = Array.new
		range = 1000
		p = rand(range)
		q = rand(range)
		while !Prime.prime?(p)
			p = rand(range)
		end		
		while !Prime.prime?(q)
			q = rand(range)
		end

		n = p * q
		keys[0] = n
		lcm = (p - 1).lcm(q - 1)

		e = rand(lcm)
		while e.gcd(lcm) != 1
			e = rand(lcm)
		end
		keys[1] = e

		d = 1
		while ((d * e)%lcm != 1)
			d = d + 1
		end
		keys[2] = d

		@rsa = Rsa.new({n: keys[0], e: keys[1], d: keys[2]})
	end

	if @rsa.save
		render json: {'id' => @rsa.id}
	end
  end

  # PATCH/PUT /rsas/1
  # PATCH/PUT /rsas/1.json
  def update
    respond_to do |format|
      if @rsa.update(rsa_params)
        format.html { redirect_to @rsa, notice: 'Rsa was successfully updated.' }
        format.json { render :show, status: :ok, location: @rsa }
      else
        format.html { render :edit }
        format.json { render json: @rsa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rsas/1
  # DELETE /rsas/1.json
  def destroy
    @rsa.destroy
    respond_to do |format|
      format.html { redirect_to rsas_url, notice: 'Rsa was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rsa
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rsa_params
      params.require(:rsa).permit(:n, :e, :d)
    end
end
