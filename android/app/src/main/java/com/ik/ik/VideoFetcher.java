package com.ik.ik;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.List;

public class VideoFetcher {
    public static List<String> getAllVideos(Context context){
        List<String> videoPaths = new ArrayList<>();
        String[] projection = {MediaStore.Video.Media.DATA};
        String orderBy = MediaStore.Video.Media.DATE_MODIFIED + " DESC";
        Uri uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        Cursor cursor = context.getContentResolver().query(uri, projection, null, null, orderBy);
        if(cursor != null){
            while(cursor.moveToNext()){
                String videoPath = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA));
                videoPaths.add(videoPath);
            }
            cursor.close();
        }
        return videoPaths;
    }
}
