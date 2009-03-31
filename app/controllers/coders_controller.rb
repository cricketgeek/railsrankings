class CodersController < ApplicationController
  
  caches_page :all_coders, :all_cities, :all_companies
  
  # GET /coders
  # GET /coders.xml
  def index
    
    @coders = Coder.search(
      (params[:search] || ""),
      :page => (params[:page] || 1),
      :per_page => SEARCH_PER_PAGE,
      :max_matches => MAX_SEARCH_RESULTS,
      :match_mode => :boolean,
      :order => :railsrank
    )
    
    @count = ThinkingSphinx::Search.count(params[:search],:match_mode => :boolean, :order => :railsrank, :max_matches => MAX_SEARCH_RESULTS)
    cookies[:search_term] = params[:search]
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @coders }
      format.json { render :json => @coders }     
    end
    
  end
  
  def all_coders
  end
  
  def all_cities
  end
  
  def all_companies
  end
  
  def all_repos
  end

  # GET /coders/1
  # GET /coders/1.xml
  def show
    @coder = Coder.find(params[:id])
    @repos = @coder.github_repos.all_popular
    @commits = @coder.recent_commits
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => [@coder,@repos,@commits]}
      format.json { render :json => [@coder,@repos,@commits]}
    end
  end
  
  def get_coders
    coder_params = params[:coders].split(",")
    coders_by_alias = get_coders_by_nickname(coder_params)
    coders_by_name = get_coders_by_name(coder_params)
    
    combo_coders = coders_by_name + coders_by_alias
    combo_coders.compact!
    combo_coders.sort! { |first,second| first.railsrank <=> second.railsrank}
    
    respond_to do |format|
      format.html
      format.json {render :json  => combo_coders}
      format.xml  {render :xml   => combo_coders}
    end
  end

  # GET /coders/new
  # GET /coders/new.xml
  def new
    @coder = Coder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coder }
    end
  end

  # GET /coders/1/edit
  def edit
    @coder = Coder.find(params[:id])
  end

  # POST /coders
  # POST /coders.xml
  def create
    @coder = Coder.new(params[:coder])

    respond_to do |format|
      if @coder.save
        flash[:notice] = 'Coder was successfully created.'
        format.html { redirect_to(@coder) }
        format.xml  { render :xml => @coder, :status => :created, :location => @coder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coders/1
  # PUT /coders/1.xml
  def update
    @coder = Coder.find(params[:id])

    respond_to do |format|
      if @coder.update_attributes(params[:coder])
        flash[:notice] = 'Coder was successfully updated.'
        format.html { redirect_to(@coder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coders/1
  # DELETE /coders/1.xml
  def destroy
    @coder = Coder.find(params[:id])
    @coder.destroy

    respond_to do |format|
      format.html { redirect_to(coders_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_coders_by_nickname(coder_params)
    coders_found = []
    coder_params.each do |param|
      new_coder = Coder.find_by_nickname(:first, :conditions => ["nickname = ?",param])
      coders_found << new_coder if new_coder
    end
    coders_found
  end
  
  def get_coders_by_name(coder_params)
    coders_found = []
    coder_params.each do |name|
      new_coder = Coder.find_by_slug(name)
      coders_found << new_coder if new_coder
    end
    
    coders_found
  end
  
  
end
