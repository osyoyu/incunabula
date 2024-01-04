module ApplicationHelper
  def entry_path(entry)
    "/blog/" + entry.entry_path
  end
end
