package org.xtext.example.mydsl;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.resource.DefaultLocationInFileProvider;
import org.eclipse.xtext.util.ITextRegion;

public class BookingDSLLocationInFileProvider extends DefaultLocationInFileProvider{
	@Override
	public ITextRegion getSignificantTextRegion(EObject obj) {
		return super.getFullTextRegion(obj);
	}
}
