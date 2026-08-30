import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// THE FIX: Safe, dynamic namespace generation that ignores evaluation timing!
subprojects {
    project.plugins.withId("com.android.library") {
        val androidExt = project.extensions.getByType(LibraryExtension::class.java)
        if (androidExt.namespace == null) {
            val fallbackNamespace = "generated.plugin.${project.name.replace("-", "_")}"
            androidExt.namespace = project.group.toString().takeIf { it.isNotEmpty() } ?: fallbackNamespace
        }
    }
}

// This MUST stay below our fix
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}