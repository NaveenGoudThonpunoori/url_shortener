class ShortUrlsController < ApplicationController
  before_action :set_short_url, only: [:edit, :update, :destroy]

  # GET /short_urls
  # GET /short_urls.json
  def index
    @short_urls = ShortUrl.all
  end

  # GET /short_urls/1
  # GET /short_urls/1.json
  def show
    if params["redirect"].present?
      @short_url =  ShortUrl.find_by(short: params[:id])

      redirect_to "#{get_sanity_url(@short_url.original).join('/')}"
    else
      @short_url =  ShortUrl.find(params[:id])
    end
  end

  # GET /short_urls/new
  def new
    @short_url = ShortUrl.new
  end

  # GET /short_urls/1/edit
  def edit
  end

  # POST /short_urls
  # POST /short_urls.json
  def create
    original_url = params[:short_url][:url]
    sanity_url = get_sanity_url(original_url)[0]
    @short_url = ShortUrl.find_by(sanity_url: sanity_url)
    if  !@short_url.present?
      short_url = create_short_url
      while ShortUrl.find_by(short: short_url).present?
        short_url = create_short_url
      end
      @short_url = ShortUrl.new(original: original_url, short: short_url, sanity_url: sanity_url)
      @short_url.save
    end
    redirect_to @short_url, notice: 'Short url was successfully created.'
  end

  # PATCH/PUT /short_urls/1
  # PATCH/PUT /short_urls/1.json
  def update
  end

  # DELETE /short_urls/1
  # DELETE /short_urls/1.json
  def destroy
    @short_url.destroy
    respond_to do |format|
      format.html { redirect_to short_urls_url, notice: 'Short url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def short_url_params
      params.require(:short_url).permit(:url)
    end

    def create_short_url
        chars = ['0'..'9', 'A'..'Z', 'a'..'z'].map { |range| range.to_a }.flatten
        6.times.map { chars.sample }.join
    end

    def get_sanity_url(original_url)
      sanity_url_arr = original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "").split("/")
      sanity_url = "http://#{sanity_url_arr[0]}"
      [sanity_url, sanity_url_arr.drop(1).join("/")]
    end
end
