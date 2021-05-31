package customhovering;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;
import org.xtext.example.mydsl.bookingDSL.System; 
import org.xtext.example.mydsl.bookingDSL.Resource; 
import org.xtext.example.mydsl.bookingDSL.Booking; 
import org.xtext.example.mydsl.bookingDSL.Customer;
import org.xtext.example.mydsl.bookingDSL.Schedule;
import org.xtext.example.mydsl.bookingDSL.Constraint;

public class BookingDSLEObjectDocumentationProvider implements IEObjectDocumentationProvider{
	@Override
	public String getDocumentation(EObject o) {
		if(o instanceof System) {
			return "system contains: "
					+ "<li>entities: generate with following syntax: entity nameOfEntity{}</li>"
					+ "<li>customers: generate with following syntax: customer nameOfCustomer{}</li>"
					+ "<li>resources: generate with following syntax: resource nameOfResource{}</li>"
					+ "<li>bookings: generate with following syntax: booking nameOfBooking{}</li>"
					+ "<li>schedules: generate with following syntax: schedule nameOfSchedule{}</li>";
		}
		
		if(o instanceof Resource) {
			return "Represents real business objects such as a seat in a theater, a room in a hotel, or similar bookable objects. "
					+ "Note that a booking should have a relation to a schedule in "
					+ "order to be bookable in the generated system.";
		}
		
		if(o instanceof Customer) {
			return "Represents the customers of the business, who can book resources.";
		}
		
		if(o instanceof Booking) {
			return "Represents the actual bookings. Note that bookings should have a relation to"
					+ "at least one schedule in order for it to be useful in the generated system.";
		}
		if(o instanceof Schedule) {
			return "The timetable for a resource. Denotes timeslots wherein a resource can be booked.";
		}
		if(o instanceof Constraint) {
			return "The entity will only be able to be created and updated if the conditions of the constraint are met. Note that the variables"
					+ "compared within the constraint must be numbers.";
		}
		
		return null;
	}
}
