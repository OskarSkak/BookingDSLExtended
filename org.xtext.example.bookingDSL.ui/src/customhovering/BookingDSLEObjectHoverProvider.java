package customhovering;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider;
import org.xtext.example.mydsl.bookingDSL.System; 


public class BookingDSLEObjectHoverProvider extends DefaultEObjectHoverProvider{
	@Override
	protected String getFirstLine(EObject o) {
		if(o instanceof System) {
			return "The system represents a whole organisation or business";
		}
		
		return super.getFirstLine(o);
	}

}
