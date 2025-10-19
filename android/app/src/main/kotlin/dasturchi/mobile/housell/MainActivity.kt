package dasturchi.mobile.housell

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        MapKitFactory.setApiKey("76676f15-9f05-4b59-9209-777978f6c997")
        super.configureFlutterEngine(flutterEngine)
        MapKitFactory.initialize(this)
    }
}