package customhovering;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;
import org.xtext.example.mydsl.bookingDSL.System; 

public class BookingDSLEObjectDocumentationProvider implements IEObjectDocumentationProvider{
	@Override
	public String getDocumentation(EObject o) {
		if(o instanceof System) {
			return "TEST OF DOCU";
		}
		return null;
	}
}
