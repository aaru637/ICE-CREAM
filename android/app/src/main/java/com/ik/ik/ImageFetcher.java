package com.ik.ik;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.List;

public class ImageFetcher {
    public static List<String> getAllImages(Context context){
        List<String> imagePaths = new ArrayList<>();
        String[] projection = {MediaStore.Images.Media.DATA};
        String orderBy = MediaStore.Images.Media.DATE_MODIFIED + " DESC";
        Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;

        Cursor cursor = context.getContentResolver().query(uri, projection, null, null, orderBy);
        if(cursor != null){
            while(cursor.moveToNext()){
                String imagePath = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA));
                imagePaths.add(imagePath);
            }
            cursor.close();
        }
        return imagePaths;
    }
}
