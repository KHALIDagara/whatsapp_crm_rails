module ContactsHelper
  def status_row_class(status)
    case status.to_sym
    when :customer
      "bg-green-50 hover:bg-green-100/60"
    when :pending
      "bg-white hover:bg-gray-50/50"
    else
      # Default background for other statuses like phase_1, phase_2, etc.
      "bg-white hover:bg-gray-50/50"
    end
  end
end
