/*
 * generated by Xtext 2.24.0
 */
package org.xtext.example.mydsl.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import static org.junit.Assert.assertTrue
import org.xtext.example.mydsl.bookingDSL.BookingDSLPackage
import javax.inject.Inject
import org.xtext.example.mydsl.parser.antlr.BookingDSLParser
import org.xtext.example.mydsl.bookingDSL.impl.SystemImpl
import org.xtext.example.mydsl.bookingDSL.Resource
import org.xtext.example.mydsl.bookingDSL.Booking
import org.xtext.example.mydsl.bookingDSL.System
import org.xtext.example.mydsl.bookingDSL.Relation
import org.xtext.example.mydsl.bookingDSL.Schedule
import org.xtext.example.mydsl.bookingDSL.Customer
import org.xtext.example.mydsl.bookingDSL.Entity
import org.xtext.example.mydsl.bookingDSL.Attribute

@ExtendWith(InjectionExtension)
@InjectWith(BookingDSLInjectorProvider)
class BookingDSLParsingTest {
	@Inject 
	ParseHelper<SystemImpl> parser
	
	@Test 
	def void T01_systemName(){
		val result = parser.parse('''
			system BookingSystem{
				
			}
		''')
		Assertions.assertNotNull(result)
		Assertions.assertTrue(result.name.equals("BookingSystem"))
	}
	
	@Test
	def void T02_resourceName(){
		val result = parser.parse('''
			system x {
				resource r{ }
			}
		''')
		Assertions.assertNotNull(result.name)
		Assertions.assertTrue(result.baseDeclaration.size==1)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Resource)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Resource).name.equals("r"))
	}
	
	@Test
	def void T03_resourcesAttributeName(){
		val result = parser.parse('''
			system x {
				resource r{
					name : string
				}
			}
		''')
		Assertions.assertNotNull(result.baseDeclaration.get(0))
		Assertions.assertTrue(((result.baseDeclaration.get(0) as Resource).eContents.get(0) as Attribute).name.equals("name"))
	}
	
	@Test
	def void T04_customerName(){
		val result = parser.parse('''
			system x {
				customer c{}
			}
		''')
		Assertions.assertNotNull(result.name)
		Assertions.assertTrue(result.baseDeclaration.size==1)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Customer)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Customer).name.equals("c"))
	}
	
	@Test
	def void T05_scheduleName(){
		val result = parser.parse('''
			system x {
				schedule s{}
			}
		''')
		Assertions.assertNotNull(result.name)
		Assertions.assertTrue(result.baseDeclaration.size==1)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Schedule)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Schedule).name.equals("s"))
	}
	
	@Test
	def void T06_bookingName(){
		val result = parser.parse('''
			system x {
				booking b{}
			}
		''')
		Assertions.assertNotNull(result.name)
		Assertions.assertTrue(result.baseDeclaration.size==1)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Booking)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Booking).name.equals("b"))
	}
	
	@Test
	def void T07_entityName(){
		val result = parser.parse('''
			system x {
				entity e{}
			}
		''')
		Assertions.assertNotNull(result.name)
		Assertions.assertTrue(result.baseDeclaration.size==1)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Entity)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Entity).name.equals("e"))
	}
	
	@Test
	def void T08_relationTypeOne(){
		val result = parser.parse('''
			system x {
				entity e{
					has one someResource : r
				}
				
				resource r{}
			}
		''')
		Assertions.assertNotNull(result.baseDeclaration.get(0))
		Assertions.assertTrue(result.baseDeclaration.size==2)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Entity)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Entity).name.equals("e"))
		Assertions.assertTrue(((result.baseDeclaration.get(0) as Entity).eContents.get(0) as Relation).plurality.equals("one"))
	}
	
	@Test
	def void T09_relationTypeMany(){
		val result = parser.parse('''
			system x {
				entity e{
					has many someResource : r
				}
				
				resource r{}
			}
		''')
		Assertions.assertNotNull(result.baseDeclaration.get(0))
		Assertions.assertTrue(result.baseDeclaration.size==2)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Entity)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Entity).name.equals("e"))
		Assertions.assertTrue(((result.baseDeclaration.get(0) as Entity).eContents.get(0) as Relation).plurality.equals("many"))
	}
	
	@Test
	def void T10_relationRefersToDeclaration(){
		val result = parser.parse('''
			system x {
				entity e{
					has many someResource : r
				}
				
				resource r{}
			}
		''')
		Assertions.assertNotNull(result.baseDeclaration.get(0))
		Assertions.assertTrue(result.baseDeclaration.size==2)
		Assertions.assertTrue(result.baseDeclaration.get(0) instanceof Entity)
		Assertions.assertTrue((result.baseDeclaration.get(0) as Entity).name.equals("e"))
		Assertions.assertTrue(((result.baseDeclaration.get(0) as Entity).eContents.get(0) as Relation).plurality.equals("many"))
		Assertions.assertEquals(result.baseDeclaration.get(1).name, 
			((result.baseDeclaration.get(0) as Entity).eContents.get(0) as Relation).relationType.name
		)
	}
	
	
}
