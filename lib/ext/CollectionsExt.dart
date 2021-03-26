
extension Collections on List{
  T find<T>(bool predication(T)){
    for(int i=0;i<length;i++){
      var element = this[i];
      if(predication(element)){
        return element;
      }
    }
    return null;
  }
}
