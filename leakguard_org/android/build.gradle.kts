// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }

// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)

// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }

// subprojects {
//     project.evaluationDependsOn(":app")
// }

// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }

// // Apply the plugins imperatively using `apply`
// apply(plugin = "org.jetbrains.kotlin.android")
// apply(plugin = "com.google.gms.google-services")
// buildscript {
//     repositories {
//         google()
//         mavenCentral()
//     }
//     dependencies {
//         classpath("com.android.tools.build:gradle:8.9.1")
//         classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20")
//         classpath("com.google.gms:google-services:4.4.2")
        
//     }
// }
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.9.0") 
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.10") 
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google() 
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
// plugins {
//   id("org.jetbrains.kotlin.android") version "1.8.22"
// }