import jenkins.*;
import jenkins.model.*;
import hudson.*;
import hudson.model.*;

mavenName = "Maven3"
mavenVersion = "3.6.0"
println("Checking Maven installations...")

// Grab the Maven "task" (which is the plugin handle).
mavenPlugin = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]

// Check for a matching installation.
maven3Install = mavenPlugin.installations.find {
   install -> install.name.equals(mavenName)
}

// If no match was found, add an installation.
if(maven3Install == null) {
   println("No Maven install found. Adding...")
   newMavenInstall = new hudson.tasks.Maven.MavenInstallation('Maven3', null, [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller(mavenVersion)])])
   mavenPlugin.installations += newMavenInstall
   mavenPlugin.save()
   println("Maven install added.")
} else {
   println("Maven install found. Done.")
}
