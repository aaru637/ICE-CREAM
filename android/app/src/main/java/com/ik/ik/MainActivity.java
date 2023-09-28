package com.ik.ik;

import android.graphics.Bitmap;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "com.ik.ik/imageFetcher";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if(Objects.equals(call.method, "getAllImages")){
                System.out.println("I'm In.");
                List<String> images = getAllImages();
                System.out.println("Hi " + Arrays.toString(images.toArray()));
                result.success(images);
            }
            else if(Objects.equals(call.method, "getAllVideos")){
                List<String> videos = getAllVideos();
                result.success(videos);
            }
            else{
                result.notImplemented();
            }
        });
    }

    private List<String> getAllImages(){
        return ImageFetcher.getAllImages(this);
    }

    private List<String> getAllVideos(){
        return VideoFetcher.getAllVideos(this);
    }
}
