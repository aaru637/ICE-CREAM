void main() {
  int iteration = 0;
  List<int> arr = [5, 3, 2, 1, 4];

  dynamic result = bubbleSort(arr, iteration);

  print(result[0]); // [1, 2, 3, 4, 5]
  print(result[1]); // 10
}

dynamic bubbleSort(List<int> arr, int iteration) {
  bool isNeedSwap = true;
  for (int i = 1; i < arr.length && isNeedSwap; i++) {
    isNeedSwap = false;
    for (int j = 0; j < (arr.length - i); j++) {
      iteration++;
      if (arr[j] > arr[j + 1]) {
        int temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        isNeedSwap = true;
      }
    }
  }
  return [arr, iteration];
}
