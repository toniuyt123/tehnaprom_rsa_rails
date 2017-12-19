class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
	protect_from_forgery with: :null_session
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
	msg = Message.find_by id: params[:id], rid: params[:rid]
	render.json: {'msg' => msg.content}
  end

  # GET /messages/new
  def new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    rsa = Rsa.find_by id: params[:id]

	encrypted = (params[:message].chars.map {|c| c.ord ** @e % @n}).join(",")
	msg = Message.new({rid: rsa.id, content: encrypted})
	if(msg.save)
		render.json: {'id' => msg.id}
	end
  end

	def decrypt
		rsa = Rsa.find_by id: params[:id]

		decrypted = (params[:message].split(",").map {|c| (c.to_i ** @d % @n).chr}).join("")
		render.json: {'content' => decrypted}
	end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:content, :id)
    end
end
