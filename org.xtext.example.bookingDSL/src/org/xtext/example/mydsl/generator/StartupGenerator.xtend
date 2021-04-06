package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.bookingDSL.*;

class StartupGenerator{
	
	static def void generateStartupFile(IFileSystemAccess2 fsa,
		Resource resource)
	{
		var systemName = resource.allContents.toList.filter(System).get(0).getName();
		
		fsa.generateFile('''«systemName»/«systemName»/Startup.cs''', 
			'''
			using «systemName».Configuration;
			using «systemName».Handlers;
			using «systemName».Persistence.Repositories;
			using Microsoft.AspNetCore.Builder;
			using Microsoft.AspNetCore.Hosting;
			using Microsoft.AspNetCore.HttpsPolicy;
			using Microsoft.AspNetCore.SpaServices.ReactDevelopmentServer;
			using Microsoft.Extensions.Configuration;
			using Microsoft.Extensions.DependencyInjection;
			using Microsoft.Extensions.Hosting;
			using Microsoft.Extensions.Options;
			using MongoDB.Driver;
			
			namespace «systemName»
			{
			    public class Startup
			    {
			        private readonly IConfiguration _configuration;
			        
			        public Startup(IConfiguration config)
			        {
			            _configuration = config;
			        }
			
			        // This method gets called by the runtime. Use this method to add services to the container.
			        public void ConfigureServices(IServiceCollection services)
			        {
			            services.AddControllersWithViews();
			            
			            // Add Configurations
			            services.Configure<PersistenceConfiguration>(_configuration.GetSection(nameof(PersistenceConfiguration)));
			            
			            // Register MongoDB database
			            services.AddSingleton<IMongoClient>(ctx => new MongoClient(ctx.GetService<IOptions<PersistenceConfiguration>>().Value.MongoClusterConnectionString));
			            
			            // Register handlers
			            services.AddScoped<IUserHandler, UserHandler>();
			
			            // Register repositories
			            services.AddScoped<IUserRepository, UserRepository>();
			            
			
			            // In production, the React files will be served from this directory
			            services.AddSpaStaticFiles(configuration => { configuration.RootPath = "ClientApp/build"; });
			        }
			
			        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
			        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
			        {
			            if (env.IsDevelopment())
			            {
			                app.UseDeveloperExceptionPage();
			            }
			            else
			            {
			                app.UseExceptionHandler("/Error");
			                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
			                app.UseHsts();
			            }
			
			            app.UseHttpsRedirection();
			            app.UseStaticFiles();
			            app.UseSpaStaticFiles();
			
			            app.UseRouting();
			
			            app.UseEndpoints(endpoints =>
			            {
			                endpoints.MapControllerRoute(
			                    name: "default",
			                    pattern: "{controller}/{action=Index}/{id?}");
			            });
			
			            app.UseSpa(spa =>
			            {
			                spa.Options.SourcePath = "ClientApp";
			
			                if (env.IsDevelopment())
			                {
			                    spa.UseReactDevelopmentServer(npmScript: "start");
			                }
			            });
			        }
			    }
			}
			''')
	}
}