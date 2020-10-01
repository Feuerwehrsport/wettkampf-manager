# frozen_string_literal: true

class ErrorsController < ApplicationController
  layout 'errors'

  def not_found
    @page_title = 'Fehler 404 - Seite nicht gefunden'
  end

  def internal_server_error
    @page_title = 'Fehler 500 - Interner Server-Fehler'
  end

  def unprocessable_entity
    @page_title = 'Fehler 422 - Unprocessable Entity'
  end
end
