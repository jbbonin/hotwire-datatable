class BooksController < ApplicationController
  before_action :find_book, only: [:edit, :update]

  def index
    @limit = params[:limit].present? ? params[:limit].to_i : 10
    @selected_page = params[:page].to_i.zero? ? 1 : params[:page].to_i

    retriever = books_retriever(@limit, @selected_page)

    @books = retriever.books
    @pages_count = retriever.pages_count

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def edit
  end

  def update
    @book.update!(permitted_params.slice(:title, :author, :publisher, :genre))
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def permitted_params
    params.require(:book).permit(:title, :author, :publisher, :genre)
  end

  def books_retriever(limit, selected_page)
    offset = (selected_page - 1) * limit
    BooksRetriever.new(params, limit, offset)
  end
end


