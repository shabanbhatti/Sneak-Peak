int getShortUniqueId() {
  int bigId = DateTime.now().microsecondsSinceEpoch;
  int shortId = bigId % 100000; 
  return shortId;
}