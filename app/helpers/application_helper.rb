module ApplicationHelper
  def entry_path(entry)
    "/breakpoint/" + entry.entry_path
  end
end
