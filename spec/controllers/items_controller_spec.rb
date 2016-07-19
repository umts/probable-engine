require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

	let!(:item) { create(:item) }
	let!(:item2) { create(:item) }

	describe 'GET #index' do
	  it 'populates an array of items' do
	    get :index
	    expect(assigns[:items]).to eq([item, item2])
	  end
	  it 'renders the :index view' do
	    get :index
	    expect(response).to render_template :index
	  end
	end

	describe 'GET #show' do
	  it 'assigns the requested item to @item' do
	    get :show, id: item
	    expect(assigns[:item]).to eq(item)
	  end
	  it 'renders the :show template' do
	    get :show, id: item
	    expect(response).to render_template :show
	  end
	end

	describe 'GET #edit' do
	  it 'assigns the requested item to @item' do
	    get :edit, id: item
	    expect(assigns[:item]).to eq(item)
	  end
	  it 'renders the :edit template' do
	    get :edit, id: item
	    expect(response).to render_template :edit
	  end
	end

	describe 'POST #update' do
	  context 'with valid attributes' do
	    it 'updates the item in the database' do
	      new_name = "TestItem"
	      post :update, id: item, item: { name: new_name }
	      item.reload
	      expect(item.name).to eq(new_name)
	    end
	    it 'redirects to the item page' do
	      new_name = "TestItem"
	      post :update, id: item, item: { name: new_name }
	      expect(response).to redirect_to item
	    end
	  end

	  context 'with invalid attributes' do
	    it 'does not save the item in the database' do
	      old_name = item.name
	      post :update, id: item, item: attributes_for(:invalid_item)
	      item.reload
	      expect(item.name).to eq(old_name)
	    end
	    it 're-renders the :edit template' do
	      post :update, id: item, item: attributes_for(:invalid_item)
	      expect(response).to render_template :edit
	    end
	  end
	end

end
