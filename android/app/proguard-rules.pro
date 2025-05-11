## From https://github.com/naver/naveridlogin-sdk-android/blob/master/Samples/proguard-rules.pro

# Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses.
-keepattributes Signature, InnerClasses, EnclosingMethod

# Retrofit does reflection on method and parameter annotations.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# Keep annotation default values (e.g., retrofit2.http.Field.encoded).
-keepattributes AnnotationDefault

# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Ignore annotation used for build tooling.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**

# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit

# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy
# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>

# Keep inherited services.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface * extends <1>

# Keep generic signature of Call, Response (R8 full mode strips signatures from non-kept items).
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

# With R8 full mode generic signatures are stripped for classes that are not
# kept. Suspend functions are wrapped in continuations where the type argument
# is used.
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# https://github.com/naver/naveridlogin-sdk-android/issues/34
-keep public class com.navercorp.nid.** { *; }
-keep public class com.nhn.android.naverlogin.** { *; }
-keep class j$.util.** { *; }

# Conscrypt와 관련된 클래스 유지
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# OpenJSSE와 관련된 클래스 유지
-keep class org.openjsse.** { *; }
-dontwarn org.openjsse.**

# OkHttp3 관련 클래스 유지
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Google 관련 클래스 유지
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# BouncyCastle 관련 클래스 유지
-keep class org.bouncycastle.jsse.** { *; }
-keep class org.bouncycastle.jsse.provider.** { *; }
-keep class org.openjsse.javax.net.ssl.** { *; }
-keep class org.openjsse.net.ssl.** { *; }

# 누락된 클래스에 대한 규칙 추가
-keep class com.android.org.conscrypt.** { *; }
-dontwarn com.android.org.conscrypt.**

-keep class org.apache.harmony.xnet.provider.jsse.** { *; }
-dontwarn org.apache.harmony.xnet.provider.jsse.**

-keep class sun.security.util.ObjectIdentifier { *; }
-dontwarn sun.security.util.ObjectIdentifier

-keep class sun.security.x509.AlgorithmId { *; }
-dontwarn sun.security.x509.AlgorithmId

# R8에서 누락된 클래스에 대한 keep 규칙 추가
-keep class com.android.org.conscrypt.** { *; }

-dontwarn com.android.org.conscrypt.SSLParametersImpl

