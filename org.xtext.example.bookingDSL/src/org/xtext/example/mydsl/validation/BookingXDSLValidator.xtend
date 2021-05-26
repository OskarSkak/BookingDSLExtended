/*
 * generated by Xtext 2.24.0
 */
package org.xtext.example.mydsl.validation

import java.util.Set
import org.eclipse.xtext.validation.Check
import org.xtext.example.mydsl.bookingDSL.Attribute
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.BookingDSLPackage
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Declaration
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Resource
import java.util.HashSet
import org.xtext.example.mydsl.bookingDSL.Relation
import org.xtext.example.mydsl.bookingDSL.Schedule

/** 
 * This class contains custom validation rules. 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class BookingXDSLValidator extends AbstractBookingDSLValidator {
	@Check def void warnIfNoDisplayName(Declaration declaration) {
		if (declaration instanceof Booking) {
			return;
		}
		var hasName = false
		var members = declaration.getMembers()
		for (var int i = 0; i < members.size(); i++) {
			var member = members.get(i)
			if (member instanceof Attribute) {
				var attriName = ((member as Attribute)).getName()
				if (attriName.equals("Name") || attriName.equals("name")) {
					hasName = true
				}
			}
		}
		if (!hasName) {
			// Return warning that there are no name attribute
			warning("This declaration has no name", BookingDSLPackage::eINSTANCE.getBaseDeclaration_Name())
			return;
		}
	}

	@Check def void errorIfDisplayNameIsNotString(Attribute attri) {
		var attriName = attri.getName()
		if (attriName.equals("name") || attriName.equals("Name")) {
			var attriType = attri.getType().getLiteral()
			if (!attriType.equals("string")) {
				error("Attribute of type name can only be of type string",
					BookingDSLPackage::eINSTANCE.getAttribute_Name())
				return; 
			}
		}
	}

	// Vars are also methods in dotnet - should be with capital letter (although not required)
	@Check def void warnIfAttributeNotCap(Attribute attri) {
		if(!Character::isUpperCase(attri.getName().charAt(0))) warning(
			"Name should start with capital since methods are directly associated in generation",
			BookingDSLPackage::eINSTANCE.getAttribute_Name())
	}

	// equally important for decs
	@Check def void warnIfDecNotCap(Declaration dec) {
		if(!Character::isUpperCase(dec.getName().charAt(0))) warning(
			"Name should start with capital since methods are directly associated in generation",
			BookingDSLPackage::eINSTANCE.getBaseDeclaration_Name())
	}

	//App wont function properly without - should be allowed in case user wants custom rules though
	@Check def void warnIfEntityHasNoRelationToResource(Entity ent) {
		var hasCorrectRelation = false
		
		for(e : ent.eContents){
			if(e instanceof Relation){
				if(e.plurality.equals("many") && e.relationType.eClass.name.equals("Resource")){
					hasCorrectRelation = true
				}
			}
		}
		
		if(!hasCorrectRelation){
			warning("Entity has no plural relation to resource - proper bookings may not be able to be made in generated application", 
				BookingDSLPackage::eINSTANCE.getBaseDeclaration_Name()
			)
		}
	}

	//App wont function properly without - should be allowed in case user wants custom rules though
	@Check def void warnIfResourceHasNoRelationToSchedule(Resource res) {
		var hasCorrectRelation = false
		
		for(e : res.eContents){
			if(e instanceof Relation){
				if(e.plurality.equals("one") && e.relationType.eClass.name.equals("Schedule")){
					hasCorrectRelation = true
				}
			}
		}
		
		if(!hasCorrectRelation){
			warning("Resource has no singular relation to schedule - proper bookings may not be able to be made in generated application", 
				BookingDSLPackage::eINSTANCE.getBaseDeclaration_Name()
			)
		}
	}

	//App wont function properly without - should be allowed in case user wants custom rules though
	@Check def void warnIfBookingHasNoRelationToSchedule(Booking book) {
		var hasCorrectRelation = false
		
		for(e : book.eContents){
			if(e instanceof Relation){
				if(e.plurality.equals("one") && e.relationType.eClass.name.equals("Schedule")){
					hasCorrectRelation = true
				}
			}
		}
		
		if(!hasCorrectRelation){
			warning("Booking has no singular relation to schedule - proper bookings may not be able to be made in generated application", 
				BookingDSLPackage::eINSTANCE.getBaseDeclaration_Name()
			)
		}
	}

	@Check def void errorOnCircularDependencies(Declaration dec) {
		for(e : dec.eContents){
			if(e instanceof Relation){
				checkForCircularDependency(e, e.relationType.name)
			}
		}
	}
	
	private def void checkForCircularDependency(Relation re, String current){
		for(e : re.relationType.eContents){
			if(e instanceof Relation){
				if(e.relationType.name.equals(current)){
					error('Cyclic dependency to ' + current, BookingDSLPackage.eINSTANCE.baseDeclaration_Name)
					return
				}
				
				e.checkForCircularDependency(current)
			}
		}
	}

	//Will break program - can not compile
	@Check def void errorOnCyclicInheretence(Customer cust) {
		val seen = new HashSet<Customer>
		seen.add(cust)
		if(cust.superType.selfExtends(seen)){
			error('Cyclic extends relation', BookingDSLPackage.eINSTANCE.baseDeclaration_Name)
		}
	}

	@Check def void errorOnCyclicInheretence(Resource res) {
		val seen = new HashSet<Resource>
		seen.add(res)
		if(res.superType.selfExtends(seen)){
			error('Cyclic extends relation', BookingDSLPackage.eINSTANCE.baseDeclaration_Name)
		}
	}

	def private boolean selfExtends(Customer c, Set<Customer> seen) {
		if (c === null)
			return false
		else if (seen.contains(c))
			return true
		else {
			seen.add(c)
			c.superType.selfExtends(seen)
		}
	}
	
	def private boolean selfExtends(Resource c, Set<Resource> seen) {
		if (c === null)
			return false
		else if (seen.contains(c))
			return true
		else {
			seen.add(c)
			c.superType.selfExtends(seen)
		}
	}

	@Check def void errorOnDuplicateName(Declaration dec) {
		val seen = new HashSet<String>
		for(m : dec.eContents){
			if(m instanceof Attribute){
				checkDuplicateAttribute(seen, m)
			}
			if(m instanceof Relation){
				checkDuplicateRelation(seen, m)
			}
		}
	}
	
	def private void checkDuplicateAttribute(HashSet<String> seen, Attribute att){
		if(seen.contains(att.name)){
					error("Duplicate names of Attributes not allowed", BookingDSLPackage.eINSTANCE.baseDeclaration_Name)
				}
		seen.add(att.name)
	} 
	
	def private void checkDuplicateRelation(HashSet<String> seen, Relation re){
		if(seen.contains(re.name)){
					error("Duplicate names of Relations not allowed", BookingDSLPackage.eINSTANCE.baseDeclaration_Name)
				}
		seen.add(re.name)
	} 
}
