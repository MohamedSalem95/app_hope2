class AppointmentUpdateJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    if appointment.status != 5
      ActionCable.server.broadcast 'appointment_channel', id: appointment.id
    end
  end
end
