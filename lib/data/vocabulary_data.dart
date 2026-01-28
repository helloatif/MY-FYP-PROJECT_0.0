// Comprehensive vocabulary data for Urdu and Punjabi lessons
// 10 chapters per language, 5 lessons per chapter, 10-15 words per lesson
// Total: 50 lessons per language, 500-750 words per language

class VocabWord {
  final String urdu;
  final String english;
  final String pronunciation;

  VocabWord({
    required this.urdu,
    required this.english,
    required this.pronunciation,
  });

  Map<String, dynamic> toMap() {
    return {'urdu': urdu, 'english': english, 'pronunciation': pronunciation};
  }
}

class LessonVocabulary {
  final int lessonNumber;
  final String title;
  final List<VocabWord> words;

  LessonVocabulary({
    required this.lessonNumber,
    required this.title,
    required this.words,
  });
}

class VocabularyData {
  // URDU CHAPTERS
  static final Map<String, List<LessonVocabulary>> urduLessons = {
    'urdu_ch1': [
      // Lesson 1: Basic Greetings & Responses
      LessonVocabulary(
        lessonNumber: 1,
        title: 'سلام و تحیات',
        words: [
          VocabWord(
            urdu: 'السلام علیکم',
            english: 'Hello/Peace be upon you',
            pronunciation: 'As-salamu alaikum',
          ),
          VocabWord(
            urdu: 'وعلیکم السلام',
            english: 'Peace be upon you too',
            pronunciation: 'Wa alaikum as-salam',
          ),
          VocabWord(
            urdu: 'صبح بخیر',
            english: 'Good morning',
            pronunciation: 'Subah bakhair',
          ),
          VocabWord(
            urdu: 'شام بخیر',
            english: 'Good evening',
            pronunciation: 'Sham bakhair',
          ),
          VocabWord(
            urdu: 'خدا حافظ',
            english: 'Goodbye',
            pronunciation: 'Khuda hafiz',
          ),
          VocabWord(
            urdu: 'الوداع',
            english: 'Farewell',
            pronunciation: 'Alvida',
          ),
          VocabWord(
            urdu: 'شکریہ',
            english: 'Thank you',
            pronunciation: 'Shukriya',
          ),
          VocabWord(
            urdu: 'مہربانی',
            english: 'Kindness/Please',
            pronunciation: 'Mehrbani',
          ),
          VocabWord(
            urdu: 'معاف کیجیے',
            english: 'Excuse me/Sorry',
            pronunciation: 'Maaf kijiye',
          ),
          VocabWord(
            urdu: 'خوش آمدید',
            english: 'Welcome',
            pronunciation: 'Khush aamdeed',
          ),
          VocabWord(
            urdu: 'کیسے ہیں',
            english: 'How are you',
            pronunciation: 'Kaise hain',
          ),
          VocabWord(
            urdu: 'میں ٹھیک ہوں',
            english: 'I am fine',
            pronunciation: 'Main theek hoon',
          ),
        ],
      ),
      // Lesson 2: Numbers 1-15
      LessonVocabulary(
        lessonNumber: 2,
        title: 'نمبر (1-15)',
        words: [
          VocabWord(urdu: 'ایک', english: 'One', pronunciation: 'Aik'),
          VocabWord(urdu: 'دو', english: 'Two', pronunciation: 'Do'),
          VocabWord(urdu: 'تین', english: 'Three', pronunciation: 'Teen'),
          VocabWord(urdu: 'چار', english: 'Four', pronunciation: 'Char'),
          VocabWord(urdu: 'پانچ', english: 'Five', pronunciation: 'Panch'),
          VocabWord(urdu: 'چھ', english: 'Six', pronunciation: 'Chay'),
          VocabWord(urdu: 'سات', english: 'Seven', pronunciation: 'Saat'),
          VocabWord(urdu: 'آٹھ', english: 'Eight', pronunciation: 'Aath'),
          VocabWord(urdu: 'نو', english: 'Nine', pronunciation: 'Nau'),
          VocabWord(urdu: 'دس', english: 'Ten', pronunciation: 'Das'),
          VocabWord(urdu: 'گیارہ', english: 'Eleven', pronunciation: 'Gyarah'),
          VocabWord(urdu: 'بارہ', english: 'Twelve', pronunciation: 'Barah'),
          VocabWord(urdu: 'تیرہ', english: 'Thirteen', pronunciation: 'Terah'),
          VocabWord(urdu: 'چودہ', english: 'Fourteen', pronunciation: 'Chodah'),
          VocabWord(
            urdu: 'پندرہ',
            english: 'Fifteen',
            pronunciation: 'Pandrah',
          ),
        ],
      ),
      // Lesson 3: Family Members
      LessonVocabulary(
        lessonNumber: 3,
        title: 'خاندان',
        words: [
          VocabWord(urdu: 'والد', english: 'Father', pronunciation: 'Walid'),
          VocabWord(urdu: 'والدہ', english: 'Mother', pronunciation: 'Walida'),
          VocabWord(urdu: 'بھائی', english: 'Brother', pronunciation: 'Bhai'),
          VocabWord(urdu: 'بہن', english: 'Sister', pronunciation: 'Behan'),
          VocabWord(
            urdu: 'دادا',
            english: 'Grandfather (paternal)',
            pronunciation: 'Dada',
          ),
          VocabWord(
            urdu: 'دادی',
            english: 'Grandmother (paternal)',
            pronunciation: 'Dadi',
          ),
          VocabWord(
            urdu: 'نانا',
            english: 'Grandfather (maternal)',
            pronunciation: 'Nana',
          ),
          VocabWord(
            urdu: 'نانی',
            english: 'Grandmother (maternal)',
            pronunciation: 'Nani',
          ),
          VocabWord(urdu: 'بیٹا', english: 'Son', pronunciation: 'Beta'),
          VocabWord(urdu: 'بیٹی', english: 'Daughter', pronunciation: 'Beti'),
          VocabWord(
            urdu: 'چچا',
            english: 'Uncle (paternal)',
            pronunciation: 'Chacha',
          ),
          VocabWord(
            urdu: 'پھوپھی',
            english: 'Aunt (paternal)',
            pronunciation: 'Phupho',
          ),
          VocabWord(
            urdu: 'ماموں',
            english: 'Uncle (maternal)',
            pronunciation: 'Mamun',
          ),
        ],
      ),
      // Lesson 4: Colors
      LessonVocabulary(
        lessonNumber: 4,
        title: 'رنگ',
        words: [
          VocabWord(urdu: 'سفید', english: 'White', pronunciation: 'Safaid'),
          VocabWord(urdu: 'کالا', english: 'Black', pronunciation: 'Kala'),
          VocabWord(urdu: 'سرخ', english: 'Red', pronunciation: 'Surkh'),
          VocabWord(urdu: 'سبز', english: 'Green', pronunciation: 'Sabz'),
          VocabWord(urdu: 'نیلا', english: 'Blue', pronunciation: 'Neela'),
          VocabWord(urdu: 'پیلا', english: 'Yellow', pronunciation: 'Peela'),
          VocabWord(
            urdu: 'نارنجی',
            english: 'Orange',
            pronunciation: 'Naranji',
          ),
          VocabWord(urdu: 'گلابی', english: 'Pink', pronunciation: 'Gulabi'),
          VocabWord(urdu: 'بھورا', english: 'Brown', pronunciation: 'Bhura'),
          VocabWord(urdu: 'جامنی', english: 'Purple', pronunciation: 'Jamni'),
          VocabWord(urdu: 'خاکی', english: 'Gray', pronunciation: 'Khaki'),
          VocabWord(urdu: 'سنہری', english: 'Golden', pronunciation: 'Sunehri'),
        ],
      ),
      // Lesson 5: Basic Objects
      LessonVocabulary(
        lessonNumber: 5,
        title: 'بنیادی چیزیں',
        words: [
          VocabWord(urdu: 'کتاب', english: 'Book', pronunciation: 'Kitab'),
          VocabWord(urdu: 'قلم', english: 'Pen', pronunciation: 'Qalam'),
          VocabWord(urdu: 'کاغذ', english: 'Paper', pronunciation: 'Kaghaz'),
          VocabWord(urdu: 'میز', english: 'Table', pronunciation: 'Maiz'),
          VocabWord(urdu: 'کرسی', english: 'Chair', pronunciation: 'Kursi'),
          VocabWord(urdu: 'دروازہ', english: 'Door', pronunciation: 'Darwaza'),
          VocabWord(urdu: 'کھڑکی', english: 'Window', pronunciation: 'Khirki'),
          VocabWord(urdu: 'گھر', english: 'House', pronunciation: 'Ghar'),
          VocabWord(urdu: 'کمرہ', english: 'Room', pronunciation: 'Kamra'),
          VocabWord(urdu: 'بستر', english: 'Bed', pronunciation: 'Bistar'),
          VocabWord(urdu: 'پنکھا', english: 'Fan', pronunciation: 'Pankha'),
          VocabWord(urdu: 'بتی', english: 'Light', pronunciation: 'Batti'),
          VocabWord(
            urdu: 'گھڑی',
            english: 'Watch/Clock',
            pronunciation: 'Gharri',
          ),
        ],
      ),
    ],

    'urdu_ch2': [
      // Lesson 1: Daily Activities
      LessonVocabulary(
        lessonNumber: 1,
        title: 'روزمرہ کے کام',
        words: [
          VocabWord(
            urdu: 'کھانا',
            english: 'Food/To eat',
            pronunciation: 'Khana',
          ),
          VocabWord(urdu: 'پینا', english: 'To drink', pronunciation: 'Peena'),
          VocabWord(urdu: 'سونا', english: 'To sleep', pronunciation: 'Sona'),
          VocabWord(
            urdu: 'جاگنا',
            english: 'To wake up',
            pronunciation: 'Jagna',
          ),
          VocabWord(
            urdu: 'پڑھنا',
            english: 'To read/study',
            pronunciation: 'Parhna',
          ),
          VocabWord(
            urdu: 'لکھنا',
            english: 'To write',
            pronunciation: 'Likhna',
          ),
          VocabWord(urdu: 'چلنا', english: 'To walk', pronunciation: 'Chalna'),
          VocabWord(urdu: 'دوڑنا', english: 'To run', pronunciation: 'Daurna'),
          VocabWord(
            urdu: 'بیٹھنا',
            english: 'To sit',
            pronunciation: 'Baithna',
          ),
          VocabWord(
            urdu: 'کھڑا ہونا',
            english: 'To stand',
            pronunciation: 'Khara hona',
          ),
          VocabWord(
            urdu: 'دیکھنا',
            english: 'To see/watch',
            pronunciation: 'Dekhna',
          ),
          VocabWord(
            urdu: 'سننا',
            english: 'To hear/listen',
            pronunciation: 'Sunna',
          ),
          VocabWord(urdu: 'بولنا', english: 'To speak', pronunciation: 'Bolna'),
        ],
      ),
      // Lesson 2: Food Items
      LessonVocabulary(
        lessonNumber: 2,
        title: 'کھانے کی چیزیں',
        words: [
          VocabWord(urdu: 'روٹی', english: 'Bread', pronunciation: 'Roti'),
          VocabWord(urdu: 'چاول', english: 'Rice', pronunciation: 'Chawal'),
          VocabWord(urdu: 'دال', english: 'Lentils', pronunciation: 'Daal'),
          VocabWord(urdu: 'گوشت', english: 'Meat', pronunciation: 'Gosht'),
          VocabWord(urdu: 'مرغی', english: 'Chicken', pronunciation: 'Murghi'),
          VocabWord(urdu: 'مچھلی', english: 'Fish', pronunciation: 'Machli'),
          VocabWord(urdu: 'دودھ', english: 'Milk', pronunciation: 'Doodh'),
          VocabWord(urdu: 'پانی', english: 'Water', pronunciation: 'Pani'),
          VocabWord(urdu: 'چائے', english: 'Tea', pronunciation: 'Chai'),
          VocabWord(urdu: 'پھل', english: 'Fruit', pronunciation: 'Phal'),
          VocabWord(urdu: 'سبزی', english: 'Vegetable', pronunciation: 'Sabzi'),
          VocabWord(urdu: 'انڈا', english: 'Egg', pronunciation: 'Anda'),
          VocabWord(urdu: 'نمک', english: 'Salt', pronunciation: 'Namak'),
          VocabWord(
            urdu: 'مرچ',
            english: 'Pepper/Chili',
            pronunciation: 'Mirch',
          ),
        ],
      ),
      // Lesson 3: Time & Days
      LessonVocabulary(
        lessonNumber: 3,
        title: 'وقت اور دن',
        words: [
          VocabWord(urdu: 'صبح', english: 'Morning', pronunciation: 'Subah'),
          VocabWord(
            urdu: 'دوپہر',
            english: 'Afternoon',
            pronunciation: 'Dopahar',
          ),
          VocabWord(urdu: 'شام', english: 'Evening', pronunciation: 'Sham'),
          VocabWord(urdu: 'رات', english: 'Night', pronunciation: 'Raat'),
          VocabWord(urdu: 'آج', english: 'Today', pronunciation: 'Aaj'),
          VocabWord(
            urdu: 'کل',
            english: 'Yesterday/Tomorrow',
            pronunciation: 'Kal',
          ),
          VocabWord(urdu: 'پیر', english: 'Monday', pronunciation: 'Peer'),
          VocabWord(urdu: 'منگل', english: 'Tuesday', pronunciation: 'Mangal'),
          VocabWord(urdu: 'بدھ', english: 'Wednesday', pronunciation: 'Budh'),
          VocabWord(
            urdu: 'جمعرات',
            english: 'Thursday',
            pronunciation: 'Jumerat',
          ),
          VocabWord(urdu: 'جمعہ', english: 'Friday', pronunciation: 'Jummah'),
          VocabWord(urdu: 'ہفتہ', english: 'Saturday', pronunciation: 'Hafta'),
          VocabWord(urdu: 'اتوار', english: 'Sunday', pronunciation: 'Itwaar'),
        ],
      ),
      // Lesson 4: Common Phrases
      LessonVocabulary(
        lessonNumber: 4,
        title: 'عام جملے',
        words: [
          VocabWord(urdu: 'ہاں', english: 'Yes', pronunciation: 'Haan'),
          VocabWord(urdu: 'نہیں', english: 'No', pronunciation: 'Nahi'),
          VocabWord(
            urdu: 'براہ کرم',
            english: 'Please',
            pronunciation: 'Barah-e-karam',
          ),
          VocabWord(urdu: 'کیوں', english: 'Why', pronunciation: 'Kyun'),
          VocabWord(urdu: 'کیا', english: 'What', pronunciation: 'Kya'),
          VocabWord(urdu: 'کہاں', english: 'Where', pronunciation: 'Kahan'),
          VocabWord(urdu: 'کب', english: 'When', pronunciation: 'Kab'),
          VocabWord(urdu: 'کیسے', english: 'How', pronunciation: 'Kaise'),
          VocabWord(urdu: 'کون', english: 'Who', pronunciation: 'Kaun'),
          VocabWord(urdu: 'کتنا', english: 'How much', pronunciation: 'Kitna'),
          VocabWord(urdu: 'یہ', english: 'This', pronunciation: 'Yeh'),
          VocabWord(urdu: 'وہ', english: 'That', pronunciation: 'Woh'),
          VocabWord(urdu: 'یہاں', english: 'Here', pronunciation: 'Yahan'),
          VocabWord(urdu: 'وہاں', english: 'There', pronunciation: 'Wahan'),
        ],
      ),
      // Lesson 5: Body Parts
      LessonVocabulary(
        lessonNumber: 5,
        title: 'جسم کے اعضاء',
        words: [
          VocabWord(urdu: 'سر', english: 'Head', pronunciation: 'Sir'),
          VocabWord(urdu: 'بال', english: 'Hair', pronunciation: 'Baal'),
          VocabWord(urdu: 'آنکھ', english: 'Eye', pronunciation: 'Aankh'),
          VocabWord(urdu: 'کان', english: 'Ear', pronunciation: 'Kaan'),
          VocabWord(urdu: 'ناک', english: 'Nose', pronunciation: 'Naak'),
          VocabWord(urdu: 'منہ', english: 'Mouth', pronunciation: 'Munh'),
          VocabWord(urdu: 'دانت', english: 'Tooth', pronunciation: 'Daant'),
          VocabWord(urdu: 'ہاتھ', english: 'Hand', pronunciation: 'Haath'),
          VocabWord(urdu: 'پاؤں', english: 'Foot', pronunciation: 'Paon'),
          VocabWord(urdu: 'انگلی', english: 'Finger', pronunciation: 'Ungli'),
          VocabWord(urdu: 'پیٹ', english: 'Stomach', pronunciation: 'Pet'),
          VocabWord(urdu: 'کمر', english: 'Back/Waist', pronunciation: 'Kamar'),
        ],
      ),
    ],

    'urdu_ch3': [
      // Lesson 1: Emotions & Feelings
      LessonVocabulary(
        lessonNumber: 1,
        title: 'جذبات',
        words: [
          VocabWord(urdu: 'خوش', english: 'Happy', pronunciation: 'Khush'),
          VocabWord(urdu: 'غمگین', english: 'Sad', pronunciation: 'Ghamgeen'),
          VocabWord(urdu: 'ناراض', english: 'Angry', pronunciation: 'Naraz'),
          VocabWord(
            urdu: 'خوفزدہ',
            english: 'Scared',
            pronunciation: 'Khaufzada',
          ),
          VocabWord(
            urdu: 'حیران',
            english: 'Surprised',
            pronunciation: 'Hairaan',
          ),
          VocabWord(
            urdu: 'تھکا ہوا',
            english: 'Tired',
            pronunciation: 'Thaka hua',
          ),
          VocabWord(urdu: 'بیمار', english: 'Sick', pronunciation: 'Bemaar'),
          VocabWord(
            urdu: 'صحت مند',
            english: 'Healthy',
            pronunciation: 'Sehat mand',
          ),
          VocabWord(
            urdu: 'پریشان',
            english: 'Worried',
            pronunciation: 'Pareshan',
          ),
          VocabWord(
            urdu: 'مطمئن',
            english: 'Content',
            pronunciation: 'Mutmain',
          ),
          VocabWord(urdu: 'محبت', english: 'Love', pronunciation: 'Mohabbat'),
          VocabWord(urdu: 'نفرت', english: 'Hate', pronunciation: 'Nafrat'),
        ],
      ),
      // Lesson 2: Weather & Nature
      LessonVocabulary(
        lessonNumber: 2,
        title: 'موسم اور قدرت',
        words: [
          VocabWord(urdu: 'سورج', english: 'Sun', pronunciation: 'Suraj'),
          VocabWord(urdu: 'چاند', english: 'Moon', pronunciation: 'Chand'),
          VocabWord(urdu: 'ستارہ', english: 'Star', pronunciation: 'Sitara'),
          VocabWord(urdu: 'بارش', english: 'Rain', pronunciation: 'Barish'),
          VocabWord(urdu: 'برف', english: 'Snow', pronunciation: 'Barf'),
          VocabWord(urdu: 'ہوا', english: 'Wind/Air', pronunciation: 'Hawa'),
          VocabWord(urdu: 'بادل', english: 'Cloud', pronunciation: 'Badal'),
          VocabWord(urdu: 'آسمان', english: 'Sky', pronunciation: 'Aasman'),
          VocabWord(
            urdu: 'زمین',
            english: 'Earth/Ground',
            pronunciation: 'Zameen',
          ),
          VocabWord(urdu: 'پہاڑ', english: 'Mountain', pronunciation: 'Pahar'),
          VocabWord(urdu: 'دریا', english: 'River', pronunciation: 'Darya'),
          VocabWord(urdu: 'درخت', english: 'Tree', pronunciation: 'Darakht'),
          VocabWord(urdu: 'پھول', english: 'Flower', pronunciation: 'Phool'),
        ],
      ),
      // Lesson 3: Animals
      LessonVocabulary(
        lessonNumber: 3,
        title: 'جانور',
        words: [
          VocabWord(urdu: 'کتا', english: 'Dog', pronunciation: 'Kutta'),
          VocabWord(urdu: 'بلی', english: 'Cat', pronunciation: 'Billi'),
          VocabWord(urdu: 'گائے', english: 'Cow', pronunciation: 'Gaaye'),
          VocabWord(urdu: 'بکری', english: 'Goat', pronunciation: 'Bakri'),
          VocabWord(urdu: 'گھوڑا', english: 'Horse', pronunciation: 'Ghora'),
          VocabWord(urdu: 'بھینس', english: 'Buffalo', pronunciation: 'Bhains'),
          VocabWord(urdu: 'شیر', english: 'Lion', pronunciation: 'Sher'),
          VocabWord(
            urdu: 'ہاتھی',
            english: 'Elephant',
            pronunciation: 'Haathi',
          ),
          VocabWord(urdu: 'بندر', english: 'Monkey', pronunciation: 'Bandar'),
          VocabWord(urdu: 'چڑیا', english: 'Bird', pronunciation: 'Chiriya'),
          VocabWord(urdu: 'طوطا', english: 'Parrot', pronunciation: 'Tota'),
          VocabWord(urdu: 'مچھر', english: 'Mosquito', pronunciation: 'Machar'),
        ],
      ),
      // Lesson 4: Places & Locations
      LessonVocabulary(
        lessonNumber: 4,
        title: 'مقامات',
        words: [
          VocabWord(urdu: 'سکول', english: 'School', pronunciation: 'School'),
          VocabWord(
            urdu: 'یونیورسٹی',
            english: 'University',
            pronunciation: 'University',
          ),
          VocabWord(
            urdu: 'ہسپتال',
            english: 'Hospital',
            pronunciation: 'Hospital',
          ),
          VocabWord(urdu: 'بازار', english: 'Market', pronunciation: 'Bazar'),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukaan'),
          VocabWord(urdu: 'مسجد', english: 'Mosque', pronunciation: 'Masjid'),
          VocabWord(urdu: 'پارک', english: 'Park', pronunciation: 'Park'),
          VocabWord(
            urdu: 'ریستوراں',
            english: 'Restaurant',
            pronunciation: 'Restaurant',
          ),
          VocabWord(urdu: 'دفتر', english: 'Office', pronunciation: 'Daftar'),
          VocabWord(
            urdu: 'لائبریری',
            english: 'Library',
            pronunciation: 'Library',
          ),
          VocabWord(
            urdu: 'سٹیشن',
            english: 'Station',
            pronunciation: 'Station',
          ),
          VocabWord(
            urdu: 'ہوائی اڈہ',
            english: 'Airport',
            pronunciation: 'Hawai adda',
          ),
        ],
      ),
      // Lesson 5: Adjectives
      LessonVocabulary(
        lessonNumber: 5,
        title: 'صفات',
        words: [
          VocabWord(urdu: 'بڑا', english: 'Big', pronunciation: 'Bara'),
          VocabWord(urdu: 'چھوٹا', english: 'Small', pronunciation: 'Chhota'),
          VocabWord(urdu: 'لمبا', english: 'Tall/Long', pronunciation: 'Lamba'),
          VocabWord(urdu: 'چوڑا', english: 'Wide', pronunciation: 'Chaura'),
          VocabWord(urdu: 'موٹا', english: 'Fat/Thick', pronunciation: 'Mota'),
          VocabWord(urdu: 'پتلا', english: 'Thin', pronunciation: 'Patla'),
          VocabWord(urdu: 'نیا', english: 'New', pronunciation: 'Naya'),
          VocabWord(urdu: 'پرانا', english: 'Old', pronunciation: 'Purana'),
          VocabWord(urdu: 'اچھا', english: 'Good', pronunciation: 'Achha'),
          VocabWord(urdu: 'برا', english: 'Bad', pronunciation: 'Bura'),
          VocabWord(
            urdu: 'خوبصورت',
            english: 'Beautiful',
            pronunciation: 'Khubsurat',
          ),
          VocabWord(urdu: 'بدصورت', english: 'Ugly', pronunciation: 'Badsurat'),
          VocabWord(urdu: 'صاف', english: 'Clean', pronunciation: 'Saaf'),
          VocabWord(urdu: 'گندا', english: 'Dirty', pronunciation: 'Ganda'),
        ],
      ),
    ],

    // CHAPTER 4: Transportation & Travel
    'urdu_ch4': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'سواریاں',
        words: [
          VocabWord(urdu: 'گاڑی', english: 'Car', pronunciation: 'Gaari'),
          VocabWord(urdu: 'بس', english: 'Bus', pronunciation: 'Bus'),
          VocabWord(urdu: 'ٹرین', english: 'Train', pronunciation: 'Train'),
          VocabWord(urdu: 'جہاز', english: 'Airplane', pronunciation: 'Jahaaz'),
          VocabWord(
            urdu: 'موٹر سائیکل',
            english: 'Motorcycle',
            pronunciation: 'Motor cycle',
          ),
          VocabWord(urdu: 'سائیکل', english: 'Bicycle', pronunciation: 'Cycle'),
          VocabWord(
            urdu: 'رکشہ',
            english: 'Rickshaw',
            pronunciation: 'Rickshaw',
          ),
          VocabWord(urdu: 'ٹیکسی', english: 'Taxi', pronunciation: 'Taxi'),
          VocabWord(urdu: 'کشتی', english: 'Boat', pronunciation: 'Kishti'),
          VocabWord(urdu: 'ٹرک', english: 'Truck', pronunciation: 'Truck'),
          VocabWord(urdu: 'وان', english: 'Van', pronunciation: 'Van'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سفر کے الفاظ',
        words: [
          VocabWord(
            urdu: 'سفر',
            english: 'Journey/Travel',
            pronunciation: 'Safar',
          ),
          VocabWord(
            urdu: 'منزل',
            english: 'Destination',
            pronunciation: 'Manzil',
          ),
          VocabWord(urdu: 'راستہ', english: 'Road/Way', pronunciation: 'Rasta'),
          VocabWord(urdu: 'پل', english: 'Bridge', pronunciation: 'Pul'),
          VocabWord(
            urdu: 'سڑک',
            english: 'Street/Road',
            pronunciation: 'Sarak',
          ),
          VocabWord(
            urdu: 'چوراہا',
            english: 'Intersection',
            pronunciation: 'Chauraha',
          ),
          VocabWord(urdu: 'ٹکٹ', english: 'Ticket', pronunciation: 'Ticket'),
          VocabWord(urdu: 'کرایہ', english: 'Fare', pronunciation: 'Kiraya'),
          VocabWord(urdu: 'سامان', english: 'Luggage', pronunciation: 'Saman'),
          VocabWord(
            urdu: 'مسافر',
            english: 'Passenger',
            pronunciation: 'Musafir',
          ),
          VocabWord(
            urdu: 'ڈرائیور',
            english: 'Driver',
            pronunciation: 'Driver',
          ),
          VocabWord(
            urdu: 'پارکنگ',
            english: 'Parking',
            pronunciation: 'Parking',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'سمتیں',
        words: [
          VocabWord(urdu: 'دائیں', english: 'Right', pronunciation: 'Dayen'),
          VocabWord(urdu: 'بائیں', english: 'Left', pronunciation: 'Bayen'),
          VocabWord(
            urdu: 'سیدھا',
            english: 'Straight',
            pronunciation: 'Seedha',
          ),
          VocabWord(urdu: 'اوپر', english: 'Up/Above', pronunciation: 'Upar'),
          VocabWord(
            urdu: 'نیچے',
            english: 'Down/Below',
            pronunciation: 'Neeche',
          ),
          VocabWord(urdu: 'سامنے', english: 'In front', pronunciation: 'Samne'),
          VocabWord(urdu: 'پیچھے', english: 'Behind', pronunciation: 'Peeche'),
          VocabWord(urdu: 'قریب', english: 'Near', pronunciation: 'Qareeb'),
          VocabWord(urdu: 'دور', english: 'Far', pronunciation: 'Door'),
          VocabWord(urdu: 'اندر', english: 'Inside', pronunciation: 'Andar'),
          VocabWord(urdu: 'باہر', english: 'Outside', pronunciation: 'Bahar'),
          VocabWord(
            urdu: 'بیچ میں',
            english: 'In the middle',
            pronunciation: 'Beech mein',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'سفری جملے',
        words: [
          VocabWord(
            urdu: 'کہاں جا رہے ہو',
            english: 'Where are you going',
            pronunciation: 'Kahan ja rahe ho',
          ),
          VocabWord(
            urdu: 'میں جا رہا ہوں',
            english: 'I am going',
            pronunciation: 'Main ja raha hoon',
          ),
          VocabWord(
            urdu: 'کتنا وقت لگے گا',
            english: 'How long will it take',
            pronunciation: 'Kitna waqt lage ga',
          ),
          VocabWord(
            urdu: 'کتنے پیسے',
            english: 'How much money',
            pronunciation: 'Kitne paise',
          ),
          VocabWord(
            urdu: 'رک جائیں',
            english: 'Please stop',
            pronunciation: 'Ruk jayen',
          ),
          VocabWord(
            urdu: 'آہستہ چلائیں',
            english: 'Drive slowly',
            pronunciation: 'Ahista chalayen',
          ),
          VocabWord(
            urdu: 'جلدی کریں',
            english: 'Hurry up',
            pronunciation: 'Jaldi karen',
          ),
          VocabWord(
            urdu: 'راستہ بتائیں',
            english: 'Show the way',
            pronunciation: 'Rasta batayen',
          ),
          VocabWord(
            urdu: 'میں کھو گیا ہوں',
            english: 'I am lost',
            pronunciation: 'Main kho gaya hoon',
          ),
          VocabWord(
            urdu: 'مدد کیجیے',
            english: 'Please help',
            pronunciation: 'Madad kijiye',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'شہر کی چیزیں',
        words: [
          VocabWord(urdu: 'شہر', english: 'City', pronunciation: 'Sheher'),
          VocabWord(urdu: 'گاؤں', english: 'Village', pronunciation: 'Gaon'),
          VocabWord(
            urdu: 'عمارت',
            english: 'Building',
            pronunciation: 'Imaarat',
          ),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukaan'),
          VocabWord(urdu: 'بینک', english: 'Bank', pronunciation: 'Bank'),
          VocabWord(
            urdu: 'پوسٹ آفس',
            english: 'Post Office',
            pronunciation: 'Post Office',
          ),
          VocabWord(
            urdu: 'پولیس سٹیشن',
            english: 'Police Station',
            pronunciation: 'Police Station',
          ),
          VocabWord(
            urdu: 'فائر بریگیڈ',
            english: 'Fire Brigade',
            pronunciation: 'Fire Brigade',
          ),
          VocabWord(
            urdu: 'میدان',
            english: 'Ground/Field',
            pronunciation: 'Maidan',
          ),
          VocabWord(urdu: 'باغ', english: 'Garden', pronunciation: 'Bagh'),
          VocabWord(
            urdu: 'چوک',
            english: 'Square/Plaza',
            pronunciation: 'Chowk',
          ),
          VocabWord(
            urdu: 'محلہ',
            english: 'Neighborhood',
            pronunciation: 'Mohalla',
          ),
        ],
      ),
    ],

    // CHAPTER 5: Food & Cooking
    'urdu_ch5': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'پھل',
        words: [
          VocabWord(urdu: 'سیب', english: 'Apple', pronunciation: 'Seb'),
          VocabWord(urdu: 'کیلا', english: 'Banana', pronunciation: 'Kela'),
          VocabWord(urdu: 'آم', english: 'Mango', pronunciation: 'Aam'),
          VocabWord(urdu: 'انگور', english: 'Grapes', pronunciation: 'Angoor'),
          VocabWord(urdu: 'سنترہ', english: 'Orange', pronunciation: 'Santra'),
          VocabWord(
            urdu: 'انار',
            english: 'Pomegranate',
            pronunciation: 'Anaar',
          ),
          VocabWord(
            urdu: 'تربوز',
            english: 'Watermelon',
            pronunciation: 'Tarbooz',
          ),
          VocabWord(
            urdu: 'خربوزہ',
            english: 'Melon',
            pronunciation: 'Kharbooza',
          ),
          VocabWord(urdu: 'آڑو', english: 'Peach', pronunciation: 'Aaroo'),
          VocabWord(
            urdu: 'ناشپاتی',
            english: 'Pear',
            pronunciation: 'Nashpati',
          ),
          VocabWord(urdu: 'املی', english: 'Tamarind', pronunciation: 'Imli'),
          VocabWord(urdu: 'لیچی', english: 'Lychee', pronunciation: 'Leechi'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سبزیاں',
        words: [
          VocabWord(urdu: 'آلو', english: 'Potato', pronunciation: 'Aloo'),
          VocabWord(urdu: 'پیاز', english: 'Onion', pronunciation: 'Pyaz'),
          VocabWord(urdu: 'ٹماٹر', english: 'Tomato', pronunciation: 'Tamatar'),
          VocabWord(urdu: 'لہسن', english: 'Garlic', pronunciation: 'Lehsan'),
          VocabWord(urdu: 'ادرک', english: 'Ginger', pronunciation: 'Adrak'),
          VocabWord(
            urdu: 'مرچ',
            english: 'Chili/Pepper',
            pronunciation: 'Mirch',
          ),
          VocabWord(
            urdu: 'گوبھی',
            english: 'Cauliflower',
            pronunciation: 'Gobhi',
          ),
          VocabWord(
            urdu: 'بینگن',
            english: 'Eggplant',
            pronunciation: 'Baingan',
          ),
          VocabWord(urdu: 'گاجر', english: 'Carrot', pronunciation: 'Gajar'),
          VocabWord(urdu: 'مٹر', english: 'Peas', pronunciation: 'Matar'),
          VocabWord(urdu: 'پالک', english: 'Spinach', pronunciation: 'Palak'),
          VocabWord(
            urdu: 'کھیرا',
            english: 'Cucumber',
            pronunciation: 'Kheera',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'مصالحے',
        words: [
          VocabWord(urdu: 'نمک', english: 'Salt', pronunciation: 'Namak'),
          VocabWord(
            urdu: 'کالی مرچ',
            english: 'Black Pepper',
            pronunciation: 'Kali Mirch',
          ),
          VocabWord(
            urdu: 'لال مرچ',
            english: 'Red Chili',
            pronunciation: 'Laal Mirch',
          ),
          VocabWord(urdu: 'ہلدی', english: 'Turmeric', pronunciation: 'Haldi'),
          VocabWord(
            urdu: 'دھنیا',
            english: 'Coriander',
            pronunciation: 'Dhaniya',
          ),
          VocabWord(urdu: 'زیرہ', english: 'Cumin', pronunciation: 'Zeera'),
          VocabWord(
            urdu: 'گرم مصالحہ',
            english: 'Garam Masala',
            pronunciation: 'Garam Masala',
          ),
          VocabWord(
            urdu: 'دار چینی',
            english: 'Cinnamon',
            pronunciation: 'Dar Cheeni',
          ),
          VocabWord(urdu: 'لونگ', english: 'Clove', pronunciation: 'Laung'),
          VocabWord(
            urdu: 'الائچی',
            english: 'Cardamom',
            pronunciation: 'Elaichi',
          ),
          VocabWord(urdu: 'تیل', english: 'Oil', pronunciation: 'Tel'),
          VocabWord(
            urdu: 'گھی',
            english: 'Ghee/Clarified butter',
            pronunciation: 'Ghee',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کھانے کی اقسام',
        words: [
          VocabWord(
            urdu: 'بریانی',
            english: 'Biryani',
            pronunciation: 'Biryani',
          ),
          VocabWord(
            urdu: 'قورمہ',
            english: 'Korma/Curry',
            pronunciation: 'Qorma',
          ),
          VocabWord(urdu: 'کباب', english: 'Kebab', pronunciation: 'Kebab'),
          VocabWord(
            urdu: 'پلاؤ',
            english: 'Pilaf/Pulao',
            pronunciation: 'Pulao',
          ),
          VocabWord(urdu: 'نان', english: 'Naan bread', pronunciation: 'Naan'),
          VocabWord(
            urdu: 'پراٹھا',
            english: 'Paratha',
            pronunciation: 'Paratha',
          ),
          VocabWord(urdu: 'سموسہ', english: 'Samosa', pronunciation: 'Samosa'),
          VocabWord(
            urdu: 'پکوڑا',
            english: 'Pakora/Fritter',
            pronunciation: 'Pakora',
          ),
          VocabWord(
            urdu: 'حلوہ',
            english: 'Halwa/Sweet',
            pronunciation: 'Halwa',
          ),
          VocabWord(
            urdu: 'کھیر',
            english: 'Rice pudding',
            pronunciation: 'Kheer',
          ),
          VocabWord(urdu: 'جلیبی', english: 'Jalebi', pronunciation: 'Jalebi'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'پکانے کے الفاظ',
        words: [
          VocabWord(urdu: 'پکانا', english: 'To cook', pronunciation: 'Pakana'),
          VocabWord(
            urdu: 'بھوننا',
            english: 'To fry/saute',
            pronunciation: 'Bhunna',
          ),
          VocabWord(
            urdu: 'ابالنا',
            english: 'To boil',
            pronunciation: 'Ubalna',
          ),
          VocabWord(
            urdu: 'بھاپ دینا',
            english: 'To steam',
            pronunciation: 'Bhaap dena',
          ),
          VocabWord(urdu: 'کاٹنا', english: 'To cut', pronunciation: 'Kaatna'),
          VocabWord(
            urdu: 'چھیلنا',
            english: 'To peel',
            pronunciation: 'Cheelna',
          ),
          VocabWord(urdu: 'دھونا', english: 'To wash', pronunciation: 'Dhona'),
          VocabWord(urdu: 'ملانا', english: 'To mix', pronunciation: 'Milana'),
          VocabWord(
            urdu: 'پیسنا',
            english: 'To grind',
            pronunciation: 'Peesna',
          ),
          VocabWord(
            urdu: 'چکھنا',
            english: 'To taste',
            pronunciation: 'Chakhna',
          ),
          VocabWord(urdu: 'چمچ', english: 'Spoon', pronunciation: 'Chamach'),
          VocabWord(urdu: 'کانٹا', english: 'Fork', pronunciation: 'Kanta'),
          VocabWord(urdu: 'چھری', english: 'Knife', pronunciation: 'Churi'),
        ],
      ),
    ],

    // CHAPTER 6: Health & Body
    'urdu_ch6': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'صحت اور بیماری',
        words: [
          VocabWord(urdu: 'صحت', english: 'Health', pronunciation: 'Sehat'),
          VocabWord(
            urdu: 'بیماری',
            english: 'Illness/Disease',
            pronunciation: 'Bimari',
          ),
          VocabWord(urdu: 'بخار', english: 'Fever', pronunciation: 'Bukhar'),
          VocabWord(urdu: 'کھانسی', english: 'Cough', pronunciation: 'Khansi'),
          VocabWord(urdu: 'زکام', english: 'Cold', pronunciation: 'Zukam'),
          VocabWord(
            urdu: 'سر درد',
            english: 'Headache',
            pronunciation: 'Sar dard',
          ),
          VocabWord(
            urdu: 'پیٹ درد',
            english: 'Stomachache',
            pronunciation: 'Pet dard',
          ),
          VocabWord(
            urdu: 'دانت درد',
            english: 'Toothache',
            pronunciation: 'Daant dard',
          ),
          VocabWord(urdu: 'درد', english: 'Pain', pronunciation: 'Dard'),
          VocabWord(
            urdu: 'زخم',
            english: 'Wound/Injury',
            pronunciation: 'Zakham',
          ),
          VocabWord(urdu: 'دوا', english: 'Medicine', pronunciation: 'Dawa'),
          VocabWord(urdu: 'ڈاکٹر', english: 'Doctor', pronunciation: 'Doctor'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'جسم کے مزید اعضاء',
        words: [
          VocabWord(urdu: 'گردن', english: 'Neck', pronunciation: 'Gardan'),
          VocabWord(
            urdu: 'کندھا',
            english: 'Shoulder',
            pronunciation: 'Kandha',
          ),
          VocabWord(urdu: 'کہنی', english: 'Elbow', pronunciation: 'Kohni'),
          VocabWord(urdu: 'کلائی', english: 'Wrist', pronunciation: 'Kalai'),
          VocabWord(urdu: 'گھٹنا', english: 'Knee', pronunciation: 'Ghutna'),
          VocabWord(urdu: 'ایڑی', english: 'Heel', pronunciation: 'Airi'),
          VocabWord(
            urdu: 'انگوٹھا',
            english: 'Thumb',
            pronunciation: 'Angutha',
          ),
          VocabWord(urdu: 'ناخن', english: 'Nail', pronunciation: 'Nakhun'),
          VocabWord(urdu: 'دل', english: 'Heart', pronunciation: 'Dil'),
          VocabWord(urdu: 'جگر', english: 'Liver', pronunciation: 'Jigar'),
          VocabWord(urdu: 'گردے', english: 'Kidneys', pronunciation: 'Gurde'),
          VocabWord(
            urdu: 'پھیپھڑے',
            english: 'Lungs',
            pronunciation: 'Phephre',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'علاج اور دیکھ بھال',
        words: [
          VocabWord(urdu: 'علاج', english: 'Treatment', pronunciation: 'Ilaaj'),
          VocabWord(
            urdu: 'آپریشن',
            english: 'Surgery/Operation',
            pronunciation: 'Operation',
          ),
          VocabWord(
            urdu: 'انجکشن',
            english: 'Injection',
            pronunciation: 'Injection',
          ),
          VocabWord(
            urdu: 'گولی',
            english: 'Pill/Tablet',
            pronunciation: 'Goli',
          ),
          VocabWord(urdu: 'شربت', english: 'Syrup', pronunciation: 'Sharbat'),
          VocabWord(urdu: 'مرہم', english: 'Ointment', pronunciation: 'Marham'),
          VocabWord(urdu: 'پٹی', english: 'Bandage', pronunciation: 'Patti'),
          VocabWord(urdu: 'نرس', english: 'Nurse', pronunciation: 'Nurse'),
          VocabWord(urdu: 'مریض', english: 'Patient', pronunciation: 'Mareez'),
          VocabWord(
            urdu: 'بستر',
            english: 'Bed (hospital)',
            pronunciation: 'Bistar',
          ),
          VocabWord(
            urdu: 'لیبارٹری',
            english: 'Laboratory',
            pronunciation: 'Laboratory',
          ),
          VocabWord(urdu: 'ٹیسٹ', english: 'Test', pronunciation: 'Test'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'صحت کے جملے',
        words: [
          VocabWord(
            urdu: 'میں بیمار ہوں',
            english: 'I am sick',
            pronunciation: 'Main bimar hoon',
          ),
          VocabWord(
            urdu: 'مجھے بخار ہے',
            english: 'I have fever',
            pronunciation: 'Mujhe bukhar hai',
          ),
          VocabWord(
            urdu: 'مجھے درد ہے',
            english: 'I have pain',
            pronunciation: 'Mujhe dard hai',
          ),
          VocabWord(
            urdu: 'آرام کریں',
            english: 'Take rest',
            pronunciation: 'Aaram karen',
          ),
          VocabWord(
            urdu: 'دوا لیں',
            english: 'Take medicine',
            pronunciation: 'Dawa len',
          ),
          VocabWord(
            urdu: 'پانی پیئں',
            english: 'Drink water',
            pronunciation: 'Pani piyen',
          ),
          VocabWord(
            urdu: 'اچھی صحت',
            english: 'Good health',
            pronunciation: 'Achhi sehat',
          ),
          VocabWord(
            urdu: 'جلد ٹھیک ہو',
            english: 'Get well soon',
            pronunciation: 'Jald theek ho',
          ),
          VocabWord(
            urdu: 'کیا تکلیف ہے',
            english: 'What is the problem',
            pronunciation: 'Kya takleef hai',
          ),
          VocabWord(
            urdu: 'ڈاکٹر کو دکھائیں',
            english: 'Show to doctor',
            pronunciation: 'Doctor ko dikhayen',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'ورزش اور فٹنس',
        words: [
          VocabWord(
            urdu: 'ورزش',
            english: 'Exercise',
            pronunciation: 'Warzish',
          ),
          VocabWord(urdu: 'دوڑنا', english: 'To run', pronunciation: 'Daurna'),
          VocabWord(urdu: 'چلنا', english: 'To walk', pronunciation: 'Chalna'),
          VocabWord(urdu: 'تیرنا', english: 'To swim', pronunciation: 'Tairna'),
          VocabWord(
            urdu: 'کھیلنا',
            english: 'To play',
            pronunciation: 'Khelna',
          ),
          VocabWord(urdu: 'یوگا', english: 'Yoga', pronunciation: 'Yoga'),
          VocabWord(urdu: 'جم', english: 'Gym', pronunciation: 'Gym'),
          VocabWord(urdu: 'طاقت', english: 'Strength', pronunciation: 'Taaqat'),
          VocabWord(
            urdu: 'توانائی',
            english: 'Energy',
            pronunciation: 'Tawanai',
          ),
          VocabWord(
            urdu: 'تھکاوٹ',
            english: 'Fatigue/Tiredness',
            pronunciation: 'Thakawat',
          ),
          VocabWord(
            urdu: 'صحت مند',
            english: 'Healthy',
            pronunciation: 'Sehat mand',
          ),
          VocabWord(urdu: 'فٹنس', english: 'Fitness', pronunciation: 'Fitness'),
        ],
      ),
    ],

    // CHAPTER 7: Education & Learning
    'urdu_ch7': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'تعلیم',
        words: [
          VocabWord(
            urdu: 'تعلیم',
            english: 'Education',
            pronunciation: 'Taleem',
          ),
          VocabWord(urdu: 'استاد', english: 'Teacher', pronunciation: 'Ustad'),
          VocabWord(
            urdu: 'طالب علم',
            english: 'Student',
            pronunciation: 'Talib-e-ilm',
          ),
          VocabWord(urdu: 'کلاس', english: 'Class', pronunciation: 'Class'),
          VocabWord(urdu: 'امتحان', english: 'Exam', pronunciation: 'Imtihan'),
          VocabWord(urdu: 'نتیجہ', english: 'Result', pronunciation: 'Nateeja'),
          VocabWord(
            urdu: 'نمبر',
            english: 'Marks/Number',
            pronunciation: 'Number',
          ),
          VocabWord(
            urdu: 'کامیابی',
            english: 'Success',
            pronunciation: 'Kamyabi',
          ),
          VocabWord(
            urdu: 'ناکامی',
            english: 'Failure',
            pronunciation: 'Nakkami',
          ),
          VocabWord(
            urdu: 'ہوم ورک',
            english: 'Homework',
            pronunciation: 'Homework',
          ),
          VocabWord(urdu: 'سبق', english: 'Lesson', pronunciation: 'Sabaq'),
          VocabWord(urdu: 'علم', english: 'Knowledge', pronunciation: 'Ilm'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'اسکول کی چیزیں',
        words: [
          VocabWord(
            urdu: 'بلیک بورڈ',
            english: 'Blackboard',
            pronunciation: 'Blackboard',
          ),
          VocabWord(urdu: 'چاک', english: 'Chalk', pronunciation: 'Chalk'),
          VocabWord(urdu: 'ربڑ', english: 'Eraser', pronunciation: 'Rubber'),
          VocabWord(urdu: 'پنسل', english: 'Pencil', pronunciation: 'Pencil'),
          VocabWord(urdu: 'رولر', english: 'Ruler', pronunciation: 'Ruler'),
          VocabWord(
            urdu: 'کمپاس',
            english: 'Compass',
            pronunciation: 'Compass',
          ),
          VocabWord(urdu: 'کتابیں', english: 'Books', pronunciation: 'Kitaben'),
          VocabWord(
            urdu: 'کاپیاں',
            english: 'Notebooks',
            pronunciation: 'Kopiyan',
          ),
          VocabWord(
            urdu: 'بستہ',
            english: 'School bag',
            pronunciation: 'Basta',
          ),
          VocabWord(
            urdu: 'ٹیبل',
            english: 'Table/Desk',
            pronunciation: 'Table',
          ),
          VocabWord(urdu: 'کرسی', english: 'Chair', pronunciation: 'Kursi'),
          VocabWord(
            urdu: 'الماری',
            english: 'Cupboard',
            pronunciation: 'Almari',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'مضامین',
        words: [
          VocabWord(
            urdu: 'ریاضی',
            english: 'Mathematics',
            pronunciation: 'Riyazi',
          ),
          VocabWord(
            urdu: 'سائنس',
            english: 'Science',
            pronunciation: 'Science',
          ),
          VocabWord(
            urdu: 'انگریزی',
            english: 'English',
            pronunciation: 'English',
          ),
          VocabWord(urdu: 'اردو', english: 'Urdu', pronunciation: 'Urdu'),
          VocabWord(
            urdu: 'اسلامیات',
            english: 'Islamic Studies',
            pronunciation: 'Islamiyat',
          ),
          VocabWord(
            urdu: 'سماجی علوم',
            english: 'Social Studies',
            pronunciation: 'Samaji Uloom',
          ),
          VocabWord(
            urdu: 'جغرافیہ',
            english: 'Geography',
            pronunciation: 'Jughrafiya',
          ),
          VocabWord(
            urdu: 'تاریخ',
            english: 'History',
            pronunciation: 'Tareekh',
          ),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'ڈرائنگ',
            english: 'Drawing',
            pronunciation: 'Drawing',
          ),
          VocabWord(urdu: 'موسیقی', english: 'Music', pronunciation: 'Moseeqi'),
          VocabWord(urdu: 'کھیل', english: 'Sports', pronunciation: 'Khel'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'پڑھائی کے الفاظ',
        words: [
          VocabWord(
            urdu: 'سیکھنا',
            english: 'To learn',
            pronunciation: 'Seekhna',
          ),
          VocabWord(
            urdu: 'پڑھنا',
            english: 'To read/study',
            pronunciation: 'Parhna',
          ),
          VocabWord(
            urdu: 'لکھنا',
            english: 'To write',
            pronunciation: 'Likhna',
          ),
          VocabWord(
            urdu: 'سمجھنا',
            english: 'To understand',
            pronunciation: 'Samajhna',
          ),
          VocabWord(
            urdu: 'یاد کرنا',
            english: 'To memorize',
            pronunciation: 'Yaad karna',
          ),
          VocabWord(
            urdu: 'دہرانا',
            english: 'To repeat/revise',
            pronunciation: 'Dohrana',
          ),
          VocabWord(
            urdu: 'حل کرنا',
            english: 'To solve',
            pronunciation: 'Hal karna',
          ),
          VocabWord(
            urdu: 'جواب دینا',
            english: 'To answer',
            pronunciation: 'Jawab dena',
          ),
          VocabWord(
            urdu: 'سوال پوچھنا',
            english: 'To ask question',
            pronunciation: 'Sawal poochna',
          ),
          VocabWord(
            urdu: 'سمجھانا',
            english: 'To explain',
            pronunciation: 'Samjhana',
          ),
          VocabWord(
            urdu: 'تعریف کرنا',
            english: 'To praise',
            pronunciation: 'Tareef karna',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'یونیورسٹی',
        words: [
          VocabWord(
            urdu: 'یونیورسٹی',
            english: 'University',
            pronunciation: 'University',
          ),
          VocabWord(urdu: 'کالج', english: 'College', pronunciation: 'College'),
          VocabWord(urdu: 'ڈگری', english: 'Degree', pronunciation: 'Degree'),
          VocabWord(
            urdu: 'پروفیسر',
            english: 'Professor',
            pronunciation: 'Professor',
          ),
          VocabWord(
            urdu: 'لیکچر',
            english: 'Lecture',
            pronunciation: 'Lecture',
          ),
          VocabWord(
            urdu: 'لیبارٹری',
            english: 'Laboratory',
            pronunciation: 'Laboratory',
          ),
          VocabWord(
            urdu: 'تحقیق',
            english: 'Research',
            pronunciation: 'Tahqeeq',
          ),
          VocabWord(urdu: 'تھیسس', english: 'Thesis', pronunciation: 'Thesis'),
          VocabWord(
            urdu: 'اسکالرشپ',
            english: 'Scholarship',
            pronunciation: 'Scholarship',
          ),
          VocabWord(
            urdu: 'سرٹیفکیٹ',
            english: 'Certificate',
            pronunciation: 'Certificate',
          ),
          VocabWord(
            urdu: 'داخلہ',
            english: 'Admission',
            pronunciation: 'Dakhila',
          ),
          VocabWord(urdu: 'فیس', english: 'Fee', pronunciation: 'Fee'),
        ],
      ),
    ],

    // CHAPTER 8: Work & Professions
    'urdu_ch8': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'پیشے',
        words: [
          VocabWord(urdu: 'ڈاکٹر', english: 'Doctor', pronunciation: 'Doctor'),
          VocabWord(
            urdu: 'انجینئر',
            english: 'Engineer',
            pronunciation: 'Engineer',
          ),
          VocabWord(urdu: 'وکیل', english: 'Lawyer', pronunciation: 'Wakeel'),
          VocabWord(urdu: 'استاد', english: 'Teacher', pronunciation: 'Ustad'),
          VocabWord(urdu: 'پائلٹ', english: 'Pilot', pronunciation: 'Pilot'),
          VocabWord(urdu: 'پولیس', english: 'Police', pronunciation: 'Police'),
          VocabWord(urdu: 'فوجی', english: 'Soldier', pronunciation: 'Fauji'),
          VocabWord(urdu: 'کسان', english: 'Farmer', pronunciation: 'Kisaan'),
          VocabWord(
            urdu: 'تاجر',
            english: 'Businessman',
            pronunciation: 'Tajir',
          ),
          VocabWord(
            urdu: 'سیلز مین',
            english: 'Salesman',
            pronunciation: 'Salesman',
          ),
          VocabWord(
            urdu: 'اکاؤنٹنٹ',
            english: 'Accountant',
            pronunciation: 'Accountant',
          ),
          VocabWord(
            urdu: 'صحافی',
            english: 'Journalist',
            pronunciation: 'Sahafi',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'دفتر کے الفاظ',
        words: [
          VocabWord(urdu: 'دفتر', english: 'Office', pronunciation: 'Daftar'),
          VocabWord(
            urdu: 'ملازم',
            english: 'Employee',
            pronunciation: 'Mulazim',
          ),
          VocabWord(
            urdu: 'مالک',
            english: 'Owner/Boss',
            pronunciation: 'Malik',
          ),
          VocabWord(
            urdu: 'مینیجر',
            english: 'Manager',
            pronunciation: 'Manager',
          ),
          VocabWord(
            urdu: 'سکریٹری',
            english: 'Secretary',
            pronunciation: 'Secretary',
          ),
          VocabWord(
            urdu: 'میٹنگ',
            english: 'Meeting',
            pronunciation: 'Meeting',
          ),
          VocabWord(urdu: 'رپورٹ', english: 'Report', pronunciation: 'Report'),
          VocabWord(urdu: 'فائل', english: 'File', pronunciation: 'File'),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'پرنٹر',
            english: 'Printer',
            pronunciation: 'Printer',
          ),
          VocabWord(urdu: 'فون', english: 'Phone', pronunciation: 'Phone'),
          VocabWord(urdu: 'ای میل', english: 'Email', pronunciation: 'Email'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'کام کے الفاظ',
        words: [
          VocabWord(urdu: 'کام', english: 'Work', pronunciation: 'Kaam'),
          VocabWord(urdu: 'نوکری', english: 'Job', pronunciation: 'Naukri'),
          VocabWord(
            urdu: 'تنخواہ',
            english: 'Salary',
            pronunciation: 'Tankhwah',
          ),
          VocabWord(
            urdu: 'چھٹی',
            english: 'Leave/Holiday',
            pronunciation: 'Chutti',
          ),
          VocabWord(
            urdu: 'حاضری',
            english: 'Attendance',
            pronunciation: 'Hazri',
          ),
          VocabWord(urdu: 'وقت', english: 'Time', pronunciation: 'Waqt'),
          VocabWord(urdu: 'ٹارگٹ', english: 'Target', pronunciation: 'Target'),
          VocabWord(
            urdu: 'ڈیڈلائن',
            english: 'Deadline',
            pronunciation: 'Deadline',
          ),
          VocabWord(
            urdu: 'پروجیکٹ',
            english: 'Project',
            pronunciation: 'Project',
          ),
          VocabWord(urdu: 'ٹیم', english: 'Team', pronunciation: 'Team'),
          VocabWord(
            urdu: 'ترقی',
            english: 'Promotion',
            pronunciation: 'Taraqi',
          ),
          VocabWord(
            urdu: 'ریٹائرمنٹ',
            english: 'Retirement',
            pronunciation: 'Retirement',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کاروبار',
        words: [
          VocabWord(
            urdu: 'کاروبار',
            english: 'Business',
            pronunciation: 'Karobar',
          ),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukaan'),
          VocabWord(urdu: 'گاہک', english: 'Customer', pronunciation: 'Gahak'),
          VocabWord(
            urdu: 'خریدنا',
            english: 'To buy',
            pronunciation: 'Khareedna',
          ),
          VocabWord(
            urdu: 'بیچنا',
            english: 'To sell',
            pronunciation: 'Baichna',
          ),
          VocabWord(urdu: 'قیمت', english: 'Price', pronunciation: 'Qeemat'),
          VocabWord(urdu: 'منافع', english: 'Profit', pronunciation: 'Munafa'),
          VocabWord(urdu: 'نقصان', english: 'Loss', pronunciation: 'Nuqsan'),
          VocabWord(
            urdu: 'سودا',
            english: 'Deal/Trade',
            pronunciation: 'Sauda',
          ),
          VocabWord(
            urdu: 'اشتہار',
            english: 'Advertisement',
            pronunciation: 'Ishtahar',
          ),
          VocabWord(
            urdu: 'مارکیٹنگ',
            english: 'Marketing',
            pronunciation: 'Marketing',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'کام کے جملے',
        words: [
          VocabWord(
            urdu: 'میں کام کرتا ہوں',
            english: 'I work',
            pronunciation: 'Main kaam karta hoon',
          ),
          VocabWord(
            urdu: 'میری نوکری ہے',
            english: 'I have a job',
            pronunciation: 'Meri naukri hai',
          ),
          VocabWord(
            urdu: 'دفتر جانا ہے',
            english: 'Have to go to office',
            pronunciation: 'Daftar jana hai',
          ),
          VocabWord(
            urdu: 'کام مکمل ہوا',
            english: 'Work completed',
            pronunciation: 'Kaam mukammal hua',
          ),
          VocabWord(
            urdu: 'چھٹی چاہیے',
            english: 'Need leave',
            pronunciation: 'Chutti chahiye',
          ),
          VocabWord(
            urdu: 'بہت کام ہے',
            english: 'Lot of work',
            pronunciation: 'Bohat kaam hai',
          ),
          VocabWord(
            urdu: 'مصروف ہوں',
            english: 'I am busy',
            pronunciation: 'Masroof hoon',
          ),
          VocabWord(
            urdu: 'فارغ ہوں',
            english: 'I am free',
            pronunciation: 'Farigh hoon',
          ),
          VocabWord(
            urdu: 'میٹنگ ہے',
            english: 'There is a meeting',
            pronunciation: 'Meeting hai',
          ),
          VocabWord(
            urdu: 'تنخواہ ملی',
            english: 'Got salary',
            pronunciation: 'Tankhwah mili',
          ),
        ],
      ),
    ],

    // CHAPTER 9: Technology & Modern Life
    'urdu_ch9': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'ٹیکنالوجی',
        words: [
          VocabWord(
            urdu: 'موبائل',
            english: 'Mobile phone',
            pronunciation: 'Mobile',
          ),
          VocabWord(
            urdu: 'لیپ ٹاپ',
            english: 'Laptop',
            pronunciation: 'Laptop',
          ),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'انٹرنیٹ',
            english: 'Internet',
            pronunciation: 'Internet',
          ),
          VocabWord(
            urdu: 'ویب سائٹ',
            english: 'Website',
            pronunciation: 'Website',
          ),
          VocabWord(urdu: 'ایپ', english: 'App', pronunciation: 'App'),
          VocabWord(
            urdu: 'سوفٹ ویئر',
            english: 'Software',
            pronunciation: 'Software',
          ),
          VocabWord(
            urdu: 'ہارڈ ویئر',
            english: 'Hardware',
            pronunciation: 'Hardware',
          ),
          VocabWord(
            urdu: 'کی بورڈ',
            english: 'Keyboard',
            pronunciation: 'Keyboard',
          ),
          VocabWord(urdu: 'ماؤس', english: 'Mouse', pronunciation: 'Mouse'),
          VocabWord(urdu: 'اسکرین', english: 'Screen', pronunciation: 'Screen'),
          VocabWord(
            urdu: 'چارجر',
            english: 'Charger',
            pronunciation: 'Charger',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سوشل میڈیا',
        words: [
          VocabWord(
            urdu: 'سوشل میڈیا',
            english: 'Social media',
            pronunciation: 'Social media',
          ),
          VocabWord(
            urdu: 'فیس بک',
            english: 'Facebook',
            pronunciation: 'Facebook',
          ),
          VocabWord(
            urdu: 'واٹس ایپ',
            english: 'WhatsApp',
            pronunciation: 'WhatsApp',
          ),
          VocabWord(
            urdu: 'انسٹاگرام',
            english: 'Instagram',
            pronunciation: 'Instagram',
          ),
          VocabWord(
            urdu: 'ٹویٹر',
            english: 'Twitter',
            pronunciation: 'Twitter',
          ),
          VocabWord(
            urdu: 'یوٹیوب',
            english: 'YouTube',
            pronunciation: 'YouTube',
          ),
          VocabWord(urdu: 'پوسٹ', english: 'Post', pronunciation: 'Post'),
          VocabWord(urdu: 'لائک', english: 'Like', pronunciation: 'Like'),
          VocabWord(urdu: 'شیئر', english: 'Share', pronunciation: 'Share'),
          VocabWord(urdu: 'کمنٹ', english: 'Comment', pronunciation: 'Comment'),
          VocabWord(urdu: 'فالو', english: 'Follow', pronunciation: 'Follow'),
          VocabWord(urdu: 'میسج', english: 'Message', pronunciation: 'Message'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'الیکٹرانکس',
        words: [
          VocabWord(
            urdu: 'ٹی وی',
            english: 'TV/Television',
            pronunciation: 'TV',
          ),
          VocabWord(urdu: 'ریڈیو', english: 'Radio', pronunciation: 'Radio'),
          VocabWord(urdu: 'کیمرہ', english: 'Camera', pronunciation: 'Camera'),
          VocabWord(
            urdu: 'ریموٹ',
            english: 'Remote control',
            pronunciation: 'Remote',
          ),
          VocabWord(
            urdu: 'بیٹری',
            english: 'Battery',
            pronunciation: 'Battery',
          ),
          VocabWord(
            urdu: 'بجلی',
            english: 'Electricity',
            pronunciation: 'Bijli',
          ),
          VocabWord(urdu: 'سوئچ', english: 'Switch', pronunciation: 'Switch'),
          VocabWord(urdu: 'پلگ', english: 'Plug', pronunciation: 'Plug'),
          VocabWord(urdu: 'تار', english: 'Wire', pronunciation: 'Taar'),
          VocabWord(
            urdu: 'ہیڈ فون',
            english: 'Headphones',
            pronunciation: 'Headphone',
          ),
          VocabWord(
            urdu: 'اسپیکر',
            english: 'Speaker',
            pronunciation: 'Speaker',
          ),
          VocabWord(
            urdu: 'مائیکروفون',
            english: 'Microphone',
            pronunciation: 'Microphone',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کمپیوٹر کے الفاظ',
        words: [
          VocabWord(urdu: 'فائل', english: 'File', pronunciation: 'File'),
          VocabWord(urdu: 'فولڈر', english: 'Folder', pronunciation: 'Folder'),
          VocabWord(
            urdu: 'ڈاؤن لوڈ',
            english: 'Download',
            pronunciation: 'Download',
          ),
          VocabWord(urdu: 'اپ لوڈ', english: 'Upload', pronunciation: 'Upload'),
          VocabWord(urdu: 'سیو', english: 'Save', pronunciation: 'Save'),
          VocabWord(urdu: 'ڈیلیٹ', english: 'Delete', pronunciation: 'Delete'),
          VocabWord(urdu: 'کاپی', english: 'Copy', pronunciation: 'Copy'),
          VocabWord(urdu: 'پیسٹ', english: 'Paste', pronunciation: 'Paste'),
          VocabWord(urdu: 'پرنٹ', english: 'Print', pronunciation: 'Print'),
          VocabWord(urdu: 'سکین', english: 'Scan', pronunciation: 'Scan'),
          VocabWord(
            urdu: 'پاس ورڈ',
            english: 'Password',
            pronunciation: 'Password',
          ),
          VocabWord(urdu: 'لاگ ان', english: 'Login', pronunciation: 'Login'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'جدید زندگی',
        words: [
          VocabWord(urdu: 'اے ٹی ایم', english: 'ATM', pronunciation: 'ATM'),
          VocabWord(
            urdu: 'کریڈٹ کارڈ',
            english: 'Credit card',
            pronunciation: 'Credit card',
          ),
          VocabWord(
            urdu: 'آن لائن',
            english: 'Online',
            pronunciation: 'Online',
          ),
          VocabWord(
            urdu: 'آف لائن',
            english: 'Offline',
            pronunciation: 'Offline',
          ),
          VocabWord(
            urdu: 'شاپنگ',
            english: 'Shopping',
            pronunciation: 'Shopping',
          ),
          VocabWord(
            urdu: 'ڈلیوری',
            english: 'Delivery',
            pronunciation: 'Delivery',
          ),
          VocabWord(urdu: 'آرڈر', english: 'Order', pronunciation: 'Order'),
          VocabWord(
            urdu: 'پیمنٹ',
            english: 'Payment',
            pronunciation: 'Payment',
          ),
          VocabWord(
            urdu: 'رجسٹریشن',
            english: 'Registration',
            pronunciation: 'Registration',
          ),
          VocabWord(
            urdu: 'اکاؤنٹ',
            english: 'Account',
            pronunciation: 'Account',
          ),
          VocabWord(urdu: 'سروس', english: 'Service', pronunciation: 'Service'),
        ],
      ),
    ],

    // CHAPTER 10: Culture & Religion
    'urdu_ch10': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'مذہب',
        words: [
          VocabWord(urdu: 'اسلام', english: 'Islam', pronunciation: 'Islam'),
          VocabWord(
            urdu: 'مسلمان',
            english: 'Muslim',
            pronunciation: 'Musalman',
          ),
          VocabWord(urdu: 'اللہ', english: 'Allah/God', pronunciation: 'Allah'),
          VocabWord(urdu: 'نماز', english: 'Prayer', pronunciation: 'Namaz'),
          VocabWord(urdu: 'روزہ', english: 'Fast', pronunciation: 'Roza'),
          VocabWord(
            urdu: 'زکوٰۃ',
            english: 'Zakat/Charity',
            pronunciation: 'Zakat',
          ),
          VocabWord(
            urdu: 'حج',
            english: 'Hajj/Pilgrimage',
            pronunciation: 'Hajj',
          ),
          VocabWord(urdu: 'قرآن', english: 'Quran', pronunciation: 'Quran'),
          VocabWord(urdu: 'حدیث', english: 'Hadith', pronunciation: 'Hadith'),
          VocabWord(urdu: 'مسجد', english: 'Mosque', pronunciation: 'Masjid'),
          VocabWord(urdu: 'امام', english: 'Imam', pronunciation: 'Imam'),
          VocabWord(urdu: 'ایمان', english: 'Faith', pronunciation: 'Iman'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'تہوار',
        words: [
          VocabWord(urdu: 'عید', english: 'Eid festival', pronunciation: 'Eid'),
          VocabWord(
            urdu: 'عید الفطر',
            english: 'Eid ul-Fitr',
            pronunciation: 'Eid ul-Fitr',
          ),
          VocabWord(
            urdu: 'عید الاضحی',
            english: 'Eid ul-Adha',
            pronunciation: 'Eid ul-Adha',
          ),
          VocabWord(urdu: 'رمضان', english: 'Ramadan', pronunciation: 'Ramzan'),
          VocabWord(
            urdu: 'محرم',
            english: 'Muharram',
            pronunciation: 'Muharram',
          ),
          VocabWord(
            urdu: 'میلاد',
            english: 'Milad/Prophet\'s birthday',
            pronunciation: 'Milad',
          ),
          VocabWord(
            urdu: 'شب برات',
            english: 'Shab-e-Barat',
            pronunciation: 'Shab-e-Barat',
          ),
          VocabWord(
            urdu: 'قربانی',
            english: 'Sacrifice',
            pronunciation: 'Qurbani',
          ),
          VocabWord(urdu: 'صدقہ', english: 'Charity', pronunciation: 'Sadqa'),
          VocabWord(
            urdu: 'دعا',
            english: 'Prayer/Supplication',
            pronunciation: 'Dua',
          ),
          VocabWord(urdu: 'برکت', english: 'Blessing', pronunciation: 'Barkat'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'ثقافت',
        words: [
          VocabWord(
            urdu: 'ثقافت',
            english: 'Culture',
            pronunciation: 'Saqafat',
          ),
          VocabWord(
            urdu: 'روایت',
            english: 'Tradition',
            pronunciation: 'Riwayat',
          ),
          VocabWord(
            urdu: 'رسم',
            english: 'Custom/Ritual',
            pronunciation: 'Rasm',
          ),
          VocabWord(urdu: 'شادی', english: 'Wedding', pronunciation: 'Shaadi'),
          VocabWord(urdu: 'دلہا', english: 'Groom', pronunciation: 'Dulha'),
          VocabWord(urdu: 'دلہن', english: 'Bride', pronunciation: 'Dulhan'),
          VocabWord(
            urdu: 'مہندی',
            english: 'Mehndi/Henna',
            pronunciation: 'Mehndi',
          ),
          VocabWord(
            urdu: 'برات',
            english: 'Wedding procession',
            pronunciation: 'Baraat',
          ),
          VocabWord(
            urdu: 'ولیمہ',
            english: 'Wedding feast',
            pronunciation: 'Walima',
          ),
          VocabWord(urdu: 'تحفہ', english: 'Gift', pronunciation: 'Tohfa'),
          VocabWord(
            urdu: 'دعوت',
            english: 'Invitation/Feast',
            pronunciation: 'Dawat',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'آداب',
        words: [
          VocabWord(
            urdu: 'ادب',
            english: 'Respect/Manner',
            pronunciation: 'Adab',
          ),
          VocabWord(
            urdu: 'احترام',
            english: 'Respect/Honor',
            pronunciation: 'Ehteram',
          ),
          VocabWord(urdu: 'سلام', english: 'Greeting', pronunciation: 'Salam'),
          VocabWord(
            urdu: 'شکر',
            english: 'Thanks/Gratitude',
            pronunciation: 'Shukar',
          ),
          VocabWord(
            urdu: 'معافی',
            english: 'Apology/Forgiveness',
            pronunciation: 'Maafi',
          ),
          VocabWord(urdu: 'مہمان', english: 'Guest', pronunciation: 'Mehman'),
          VocabWord(urdu: 'میزبان', english: 'Host', pronunciation: 'Mezbaan'),
          VocabWord(
            urdu: 'مہمان نوازی',
            english: 'Hospitality',
            pronunciation: 'Mehman nawazi',
          ),
          VocabWord(
            urdu: 'عزت',
            english: 'Honor/Dignity',
            pronunciation: 'Izzat',
          ),
          VocabWord(urdu: 'امانت', english: 'Trust', pronunciation: 'Amanat'),
          VocabWord(
            urdu: 'سچائی',
            english: 'Truth/Honesty',
            pronunciation: 'Sachai',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'پاکستانی ثقافت',
        words: [
          VocabWord(
            urdu: 'پاکستان',
            english: 'Pakistan',
            pronunciation: 'Pakistan',
          ),
          VocabWord(
            urdu: 'قومی ترانہ',
            english: 'National anthem',
            pronunciation: 'Qaumi tarana',
          ),
          VocabWord(urdu: 'جھنڈا', english: 'Flag', pronunciation: 'Jhanda'),
          VocabWord(urdu: 'ہلال', english: 'Crescent', pronunciation: 'Hilal'),
          VocabWord(urdu: 'ستارہ', english: 'Star', pronunciation: 'Sitara'),
          VocabWord(urdu: 'سبز', english: 'Green', pronunciation: 'Sabz'),
          VocabWord(urdu: 'سفید', english: 'White', pronunciation: 'Safaid'),
          VocabWord(
            urdu: 'یوم آزادی',
            english: 'Independence Day',
            pronunciation: 'Youm-e-Azadi',
          ),
          VocabWord(
            urdu: 'یوم پاکستان',
            english: 'Pakistan Day',
            pronunciation: 'Youm-e-Pakistan',
          ),
          VocabWord(
            urdu: 'قائد اعظم',
            english: 'Quaid-e-Azam',
            pronunciation: 'Quaid-e-Azam',
          ),
          VocabWord(
            urdu: 'علامہ اقبال',
            english: 'Allama Iqbal',
            pronunciation: 'Allama Iqbal',
          ),
        ],
      ),
    ],
  };

  // PUNJABI CHAPTERS (Shahmukhi script)
  static final Map<String, List<LessonVocabulary>> punjabiLessons = {
    'punjabi_ch1': [
      // Lesson 1: Basic Greetings
      LessonVocabulary(
        lessonNumber: 1,
        title: 'سلام تے جواب',
        words: [
          VocabWord(
            urdu: 'ست سری اکال',
            english: 'Hello (Sikh greeting)',
            pronunciation: 'Sat sri akal',
          ),
          VocabWord(
            urdu: 'السلام علیکم',
            english: 'Hello (Muslim greeting)',
            pronunciation: 'As-salamu alaikum',
          ),
          VocabWord(
            urdu: 'کی حال اے',
            english: 'How are you',
            pronunciation: 'Ki haal ae',
          ),
          VocabWord(
            urdu: 'میں ٹھیک آں',
            english: 'I am fine',
            pronunciation: 'Main theek aan',
          ),
          VocabWord(
            urdu: 'شکریہ',
            english: 'Thank you',
            pronunciation: 'Shukriya',
          ),
          VocabWord(
            urdu: 'خوش آمدید',
            english: 'Welcome',
            pronunciation: 'Khush aamaded',
          ),
          VocabWord(
            urdu: 'الوداع',
            english: 'Goodbye',
            pronunciation: 'Alvida',
          ),
          VocabWord(
            urdu: 'معاف کرو',
            english: 'Sorry/Excuse me',
            pronunciation: 'Maaf karo',
          ),
          VocabWord(
            urdu: 'صبح بخیر',
            english: 'Good morning',
            pronunciation: 'Subah bakhair',
          ),
          VocabWord(
            urdu: 'شام بخیر',
            english: 'Good evening',
            pronunciation: 'Sham bakhair',
          ),
          VocabWord(
            urdu: 'راب راکھا',
            english: 'God bless',
            pronunciation: 'Rab rakha',
          ),
        ],
      ),
      // Lesson 2: Numbers 1-15
      LessonVocabulary(
        lessonNumber: 2,
        title: 'گنتی (1-15)',
        words: [
          VocabWord(urdu: 'اک', english: 'One', pronunciation: 'Ikk'),
          VocabWord(urdu: 'دو', english: 'Two', pronunciation: 'Do'),
          VocabWord(urdu: 'تن', english: 'Three', pronunciation: 'Tinn'),
          VocabWord(urdu: 'چار', english: 'Four', pronunciation: 'Char'),
          VocabWord(urdu: 'پنج', english: 'Five', pronunciation: 'Panj'),
          VocabWord(urdu: 'چھے', english: 'Six', pronunciation: 'Chhe'),
          VocabWord(urdu: 'ست', english: 'Seven', pronunciation: 'Satt'),
          VocabWord(urdu: 'اٹھ', english: 'Eight', pronunciation: 'Atth'),
          VocabWord(urdu: 'نو', english: 'Nine', pronunciation: 'Nau'),
          VocabWord(urdu: 'دس', english: 'Das', pronunciation: 'Das'),
          VocabWord(urdu: 'گیارہ', english: 'Eleven', pronunciation: 'Gyara'),
          VocabWord(urdu: 'بارہ', english: 'Twelve', pronunciation: 'Bara'),
          VocabWord(urdu: 'تیرہ', english: 'Thirteen', pronunciation: 'Tera'),
          VocabWord(urdu: 'چودہ', english: 'Fourteen', pronunciation: 'Chauda'),
          VocabWord(urdu: 'پندرہ', english: 'Fifteen', pronunciation: 'Pandra'),
        ],
      ),
      // Lesson 3: Family
      LessonVocabulary(
        lessonNumber: 3,
        title: 'خاندان',
        words: [
          VocabWord(urdu: 'ابا', english: 'Father', pronunciation: 'Abba'),
          VocabWord(urdu: 'ماں', english: 'Mother', pronunciation: 'Maan'),
          VocabWord(urdu: 'بھرا', english: 'Brother', pronunciation: 'Bhra'),
          VocabWord(urdu: 'بھین', english: 'Sister', pronunciation: 'Bhain'),
          VocabWord(
            urdu: 'دادا',
            english: 'Grandfather (paternal)',
            pronunciation: 'Dada',
          ),
          VocabWord(
            urdu: 'دادی',
            english: 'Grandmother (paternal)',
            pronunciation: 'Dadi',
          ),
          VocabWord(
            urdu: 'نانا',
            english: 'Grandfather (maternal)',
            pronunciation: 'Nana',
          ),
          VocabWord(
            urdu: 'نانی',
            english: 'Grandmother (maternal)',
            pronunciation: 'Nani',
          ),
          VocabWord(urdu: 'پتر', english: 'Son', pronunciation: 'Putt'),
          VocabWord(urdu: 'دھی', english: 'Daughter', pronunciation: 'Dhee'),
          VocabWord(
            urdu: 'چاچا',
            english: 'Uncle (paternal)',
            pronunciation: 'Chacha',
          ),
          VocabWord(
            urdu: 'ماسی',
            english: 'Aunt (maternal)',
            pronunciation: 'Masi',
          ),
        ],
      ),
      // Lesson 4: Colors
      LessonVocabulary(
        lessonNumber: 4,
        title: 'رنگ',
        words: [
          VocabWord(urdu: 'چٹا', english: 'White', pronunciation: 'Chitta'),
          VocabWord(urdu: 'کالا', english: 'Black', pronunciation: 'Kala'),
          VocabWord(urdu: 'لال', english: 'Red', pronunciation: 'Laal'),
          VocabWord(urdu: 'ہرا', english: 'Green', pronunciation: 'Hara'),
          VocabWord(urdu: 'نیلا', english: 'Blue', pronunciation: 'Neela'),
          VocabWord(urdu: 'پیلا', english: 'Yellow', pronunciation: 'Peela'),
          VocabWord(
            urdu: 'نارنگی',
            english: 'Orange',
            pronunciation: 'Narangi',
          ),
          VocabWord(urdu: 'گلابی', english: 'Pink', pronunciation: 'Gulabi'),
          VocabWord(urdu: 'بھورا', english: 'Brown', pronunciation: 'Bhura'),
          VocabWord(
            urdu: 'بینگنی',
            english: 'Purple',
            pronunciation: 'Baingni',
          ),
          VocabWord(urdu: 'سلیٹی', english: 'Gray', pronunciation: 'Sleti'),
        ],
      ),
      // Lesson 5: Basic Objects
      LessonVocabulary(
        lessonNumber: 5,
        title: 'روزمرہ دیاں چیزاں',
        words: [
          VocabWord(urdu: 'کتاب', english: 'Book', pronunciation: 'Kitab'),
          VocabWord(urdu: 'قلم', english: 'Pen', pronunciation: 'Qalam'),
          VocabWord(urdu: 'کاغذ', english: 'Paper', pronunciation: 'Kaghaz'),
          VocabWord(urdu: 'میز', english: 'Table', pronunciation: 'Maiz'),
          VocabWord(urdu: 'کرسی', english: 'Chair', pronunciation: 'Kursi'),
          VocabWord(urdu: 'دروازہ', english: 'Door', pronunciation: 'Darwaza'),
          VocabWord(urdu: 'کھڑکی', english: 'Window', pronunciation: 'Khirki'),
          VocabWord(urdu: 'گھر', english: 'House', pronunciation: 'Ghar'),
          VocabWord(urdu: 'کمرہ', english: 'Room', pronunciation: 'Kamra'),
          VocabWord(urdu: 'پلنگ', english: 'Bed', pronunciation: 'Palang'),
          VocabWord(urdu: 'پنکھا', english: 'Fan', pronunciation: 'Pankha'),
          VocabWord(urdu: 'بتی', english: 'Light', pronunciation: 'Batti'),
        ],
      ),
    ],

    'punjabi_ch2': [
      // Lesson 1: Daily Activities
      LessonVocabulary(
        lessonNumber: 1,
        title: 'روزمرہ دے کم',
        words: [
          VocabWord(urdu: 'کھانا', english: 'To eat', pronunciation: 'Khana'),
          VocabWord(urdu: 'پینا', english: 'To drink', pronunciation: 'Peena'),
          VocabWord(urdu: 'سونا', english: 'To sleep', pronunciation: 'Sona'),
          VocabWord(
            urdu: 'جگنا',
            english: 'To wake up',
            pronunciation: 'Jagna',
          ),
          VocabWord(urdu: 'پڑھنا', english: 'To read', pronunciation: 'Parhna'),
          VocabWord(
            urdu: 'لکھنا',
            english: 'To write',
            pronunciation: 'Likhna',
          ),
          VocabWord(urdu: 'چلنا', english: 'To walk', pronunciation: 'Chalna'),
          VocabWord(urdu: 'دوڑنا', english: 'To run', pronunciation: 'Daurna'),
          VocabWord(urdu: 'بہنا', english: 'To sit', pronunciation: 'Baina'),
          VocabWord(
            urdu: 'کھڑا ہونا',
            english: 'To stand',
            pronunciation: 'Khara hona',
          ),
          VocabWord(
            urdu: 'ویکھنا',
            english: 'To see',
            pronunciation: 'Vaikhna',
          ),
          VocabWord(urdu: 'سننا', english: 'To listen', pronunciation: 'Sunna'),
        ],
      ),
      // Lesson 2: Food
      LessonVocabulary(
        lessonNumber: 2,
        title: 'کھاݨ والیاں چیزاں',
        words: [
          VocabWord(urdu: 'روٹی', english: 'Bread', pronunciation: 'Roti'),
          VocabWord(urdu: 'چاول', english: 'Rice', pronunciation: 'Chawal'),
          VocabWord(urdu: 'دال', english: 'Lentils', pronunciation: 'Daal'),
          VocabWord(urdu: 'گوشت', english: 'Meat', pronunciation: 'Gosht'),
          VocabWord(urdu: 'ککڑی', english: 'Chicken', pronunciation: 'Kukkar'),
          VocabWord(urdu: 'مچھلی', english: 'Fish', pronunciation: 'Machli'),
          VocabWord(urdu: 'دُدھ', english: 'Milk', pronunciation: 'Dudh'),
          VocabWord(urdu: 'پانی', english: 'Water', pronunciation: 'Pani'),
          VocabWord(urdu: 'چاہ', english: 'Tea', pronunciation: 'Chah'),
          VocabWord(urdu: 'پھل', english: 'Fruit', pronunciation: 'Phal'),
          VocabWord(
            urdu: 'ترکاری',
            english: 'Vegetable',
            pronunciation: 'Tarkari',
          ),
          VocabWord(urdu: 'انڈا', english: 'Egg', pronunciation: 'Anda'),
          VocabWord(urdu: 'لون', english: 'Salt', pronunciation: 'Loon'),
        ],
      ),
      // Lesson 3: Time & Days
      LessonVocabulary(
        lessonNumber: 3,
        title: 'ویلا تے دن',
        words: [
          VocabWord(urdu: 'صبح', english: 'Morning', pronunciation: 'Subah'),
          VocabWord(
            urdu: 'دوپہر',
            english: 'Afternoon',
            pronunciation: 'Dopahar',
          ),
          VocabWord(urdu: 'شام', english: 'Evening', pronunciation: 'Sham'),
          VocabWord(urdu: 'رات', english: 'Night', pronunciation: 'Raat'),
          VocabWord(urdu: 'اج', english: 'Today', pronunciation: 'Aj'),
          VocabWord(
            urdu: 'کل',
            english: 'Yesterday/Tomorrow',
            pronunciation: 'Kal',
          ),
          VocabWord(
            urdu: 'سوموار',
            english: 'Monday',
            pronunciation: 'Somwaar',
          ),
          VocabWord(urdu: 'منگل', english: 'Tuesday', pronunciation: 'Mangal'),
          VocabWord(
            urdu: 'بدھوار',
            english: 'Wednesday',
            pronunciation: 'Budhwaar',
          ),
          VocabWord(
            urdu: 'جمعرات',
            english: 'Thursday',
            pronunciation: 'Jumerat',
          ),
          VocabWord(urdu: 'جمعہ', english: 'Friday', pronunciation: 'Jummah'),
          VocabWord(urdu: 'ہفتہ', english: 'Saturday', pronunciation: 'Hafta'),
          VocabWord(urdu: 'اتوار', english: 'Sunday', pronunciation: 'Itwaar'),
        ],
      ),
      // Lesson 4: Common Phrases
      LessonVocabulary(
        lessonNumber: 4,
        title: 'عام فقرے',
        words: [
          VocabWord(urdu: 'ہاں', english: 'Yes', pronunciation: 'Haan'),
          VocabWord(urdu: 'نہیں', english: 'No', pronunciation: 'Nai'),
          VocabWord(
            urdu: 'مہربانی',
            english: 'Please',
            pronunciation: 'Mehrbani',
          ),
          VocabWord(urdu: 'کیوں', english: 'Why', pronunciation: 'Kyon'),
          VocabWord(urdu: 'کی', english: 'What', pronunciation: 'Ki'),
          VocabWord(urdu: 'کتھے', english: 'Where', pronunciation: 'Kithe'),
          VocabWord(urdu: 'کدوں', english: 'When', pronunciation: 'Kadon'),
          VocabWord(urdu: 'کویں', english: 'How', pronunciation: 'Kiven'),
          VocabWord(urdu: 'کون', english: 'Who', pronunciation: 'Kaun'),
          VocabWord(urdu: 'کنا', english: 'How much', pronunciation: 'Kinna'),
          VocabWord(urdu: 'ایہ', english: 'This', pronunciation: 'Eh'),
          VocabWord(urdu: 'اوہ', english: 'That', pronunciation: 'Oh'),
          VocabWord(urdu: 'ایتھے', english: 'Here', pronunciation: 'Ethe'),
        ],
      ),
      // Lesson 5: Body Parts
      LessonVocabulary(
        lessonNumber: 5,
        title: 'جسم دے انگ',
        words: [
          VocabWord(urdu: 'سر', english: 'Head', pronunciation: 'Sir'),
          VocabWord(urdu: 'وال', english: 'Hair', pronunciation: 'Waal'),
          VocabWord(urdu: 'اکھ', english: 'Eye', pronunciation: 'Akkh'),
          VocabWord(urdu: 'کن', english: 'Ear', pronunciation: 'Kann'),
          VocabWord(urdu: 'نک', english: 'Nose', pronunciation: 'Nakk'),
          VocabWord(urdu: 'منہ', english: 'Mouth', pronunciation: 'Munh'),
          VocabWord(urdu: 'دند', english: 'Tooth', pronunciation: 'Dand'),
          VocabWord(urdu: 'ہتھ', english: 'Hand', pronunciation: 'Hath'),
          VocabWord(urdu: 'پیر', english: 'Foot', pronunciation: 'Pair'),
          VocabWord(urdu: 'انگل', english: 'Finger', pronunciation: 'Angal'),
          VocabWord(urdu: 'پیٹ', english: 'Stomach', pronunciation: 'Pet'),
          VocabWord(urdu: 'پٹھ', english: 'Back', pronunciation: 'Pitth'),
        ],
      ),
    ],

    'punjabi_ch3': [
      // Lesson 1: Emotions
      LessonVocabulary(
        lessonNumber: 1,
        title: 'جذبات',
        words: [
          VocabWord(urdu: 'خوش', english: 'Happy', pronunciation: 'Khush'),
          VocabWord(urdu: 'اداس', english: 'Sad', pronunciation: 'Udaas'),
          VocabWord(urdu: 'گصہ', english: 'Angry', pronunciation: 'Gussa'),
          VocabWord(urdu: 'ڈر', english: 'Fear', pronunciation: 'Dar'),
          VocabWord(
            urdu: 'حیران',
            english: 'Surprised',
            pronunciation: 'Hairaan',
          ),
          VocabWord(urdu: 'تھکیا', english: 'Tired', pronunciation: 'Thakeya'),
          VocabWord(urdu: 'بیمار', english: 'Sick', pronunciation: 'Bimaar'),
          VocabWord(
            urdu: 'تندرست',
            english: 'Healthy',
            pronunciation: 'Tandurust',
          ),
          VocabWord(
            urdu: 'پریشان',
            english: 'Worried',
            pronunciation: 'Pareshan',
          ),
          VocabWord(
            urdu: 'چنگا',
            english: 'Good/Well',
            pronunciation: 'Changa',
          ),
          VocabWord(urdu: 'پیار', english: 'Love', pronunciation: 'Pyar'),
        ],
      ),
      // Lesson 2: Weather & Nature
      LessonVocabulary(
        lessonNumber: 2,
        title: 'موسم تے قدرت',
        words: [
          VocabWord(urdu: 'سورج', english: 'Sun', pronunciation: 'Suraj'),
          VocabWord(urdu: 'چن', english: 'Moon', pronunciation: 'Chan'),
          VocabWord(urdu: 'تارا', english: 'Star', pronunciation: 'Tara'),
          VocabWord(urdu: 'مینہہ', english: 'Rain', pronunciation: 'Menh'),
          VocabWord(urdu: 'برف', english: 'Snow', pronunciation: 'Barf'),
          VocabWord(urdu: 'ہوا', english: 'Wind', pronunciation: 'Hawa'),
          VocabWord(urdu: 'بدل', english: 'Cloud', pronunciation: 'Badal'),
          VocabWord(urdu: 'آسمان', english: 'Sky', pronunciation: 'Aasman'),
          VocabWord(urdu: 'زمین', english: 'Earth', pronunciation: 'Zameen'),
          VocabWord(urdu: 'پہاڑ', english: 'Mountain', pronunciation: 'Pahar'),
          VocabWord(urdu: 'دریا', english: 'River', pronunciation: 'Darya'),
          VocabWord(urdu: 'رکھ', english: 'Tree', pronunciation: 'Rukh'),
          VocabWord(urdu: 'پھل', english: 'Flower', pronunciation: 'Phull'),
        ],
      ),
      // Lesson 3: Animals
      LessonVocabulary(
        lessonNumber: 3,
        title: 'جانور',
        words: [
          VocabWord(urdu: 'کتا', english: 'Dog', pronunciation: 'Kutta'),
          VocabWord(urdu: 'بلی', english: 'Cat', pronunciation: 'Billi'),
          VocabWord(urdu: 'گاں', english: 'Cow', pronunciation: 'Gaan'),
          VocabWord(urdu: 'بکری', english: 'Goat', pronunciation: 'Bakri'),
          VocabWord(urdu: 'گھوڑا', english: 'Horse', pronunciation: 'Ghora'),
          VocabWord(urdu: 'بھینس', english: 'Buffalo', pronunciation: 'Bhains'),
          VocabWord(urdu: 'شیر', english: 'Lion', pronunciation: 'Sher'),
          VocabWord(
            urdu: 'ہاتھی',
            english: 'Elephant',
            pronunciation: 'Haathi',
          ),
          VocabWord(urdu: 'بندر', english: 'Monkey', pronunciation: 'Bandar'),
          VocabWord(urdu: 'چڑی', english: 'Bird', pronunciation: 'Chirri'),
          VocabWord(urdu: 'طوطا', english: 'Parrot', pronunciation: 'Tota'),
        ],
      ),
      // Lesson 4: Places
      LessonVocabulary(
        lessonNumber: 4,
        title: 'تھاواں',
        words: [
          VocabWord(urdu: 'سکول', english: 'School', pronunciation: 'School'),
          VocabWord(urdu: 'کالج', english: 'College', pronunciation: 'College'),
          VocabWord(
            urdu: 'ہسپتال',
            english: 'Hospital',
            pronunciation: 'Hospital',
          ),
          VocabWord(urdu: 'بازار', english: 'Market', pronunciation: 'Bazar'),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukan'),
          VocabWord(
            urdu: 'گردوارہ',
            english: 'Gurdwara',
            pronunciation: 'Gurdwara',
          ),
          VocabWord(urdu: 'مسیت', english: 'Mosque', pronunciation: 'Masjid'),
          VocabWord(urdu: 'پارک', english: 'Park', pronunciation: 'Park'),
          VocabWord(urdu: 'دفتر', english: 'Office', pronunciation: 'Daftar'),
          VocabWord(
            urdu: 'لائبریری',
            english: 'Library',
            pronunciation: 'Library',
          ),
          VocabWord(
            urdu: 'سٹیشن',
            english: 'Station',
            pronunciation: 'Station',
          ),
        ],
      ),
      // Lesson 5: Adjectives
      LessonVocabulary(
        lessonNumber: 5,
        title: 'صفتاں',
        words: [
          VocabWord(urdu: 'وڈا', english: 'Big', pronunciation: 'Wadda'),
          VocabWord(urdu: 'نکا', english: 'Small', pronunciation: 'Nikka'),
          VocabWord(urdu: 'لما', english: 'Tall/Long', pronunciation: 'Lamma'),
          VocabWord(urdu: 'چوڑا', english: 'Wide', pronunciation: 'Chaura'),
          VocabWord(urdu: 'موٹا', english: 'Fat', pronunciation: 'Mota'),
          VocabWord(urdu: 'پتلا', english: 'Thin', pronunciation: 'Patla'),
          VocabWord(urdu: 'نواں', english: 'New', pronunciation: 'Nawan'),
          VocabWord(urdu: 'پرانا', english: 'Old', pronunciation: 'Purana'),
          VocabWord(urdu: 'چنگا', english: 'Good', pronunciation: 'Changa'),
          VocabWord(urdu: 'مادا', english: 'Bad', pronunciation: 'Mada'),
          VocabWord(
            urdu: 'سندر',
            english: 'Beautiful',
            pronunciation: 'Sundar',
          ),
          VocabWord(urdu: 'صاف', english: 'Clean', pronunciation: 'Saaf'),
          VocabWord(urdu: 'گندا', english: 'Dirty', pronunciation: 'Ganda'),
        ],
      ),
    ],

    // CHAPTER 4-10: Additional Punjabi Chapters
    'punjabi_ch4': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'سواریاں',
        words: [
          VocabWord(urdu: 'گڈی', english: 'Car', pronunciation: 'Gaddi'),
          VocabWord(urdu: 'بس', english: 'Bus', pronunciation: 'Bus'),
          VocabWord(
            urdu: 'ریل گڈی',
            english: 'Train',
            pronunciation: 'Rail gaddi',
          ),
          VocabWord(
            urdu: 'ہوائی جہاز',
            english: 'Airplane',
            pronunciation: 'Hawai jahaaz',
          ),
          VocabWord(
            urdu: 'موٹر سائیکل',
            english: 'Motorcycle',
            pronunciation: 'Motor cycle',
          ),
          VocabWord(urdu: 'سائیکل', english: 'Bicycle', pronunciation: 'Cycle'),
          VocabWord(
            urdu: 'رکشہ',
            english: 'Rickshaw',
            pronunciation: 'Rickshaw',
          ),
          VocabWord(urdu: 'ٹیکسی', english: 'Taxi', pronunciation: 'Taxi'),
          VocabWord(urdu: 'کشتی', english: 'Boat', pronunciation: 'Kishti'),
          VocabWord(urdu: 'ٹرک', english: 'Truck', pronunciation: 'Truck'),
          VocabWord(
            urdu: 'ٹانگہ',
            english: 'Horse cart',
            pronunciation: 'Tanga',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سفر دے الفاظ',
        words: [
          VocabWord(urdu: 'سفر', english: 'Journey', pronunciation: 'Safar'),
          VocabWord(
            urdu: 'منزل',
            english: 'Destination',
            pronunciation: 'Manzil',
          ),
          VocabWord(urdu: 'رستہ', english: 'Road/Way', pronunciation: 'Rasta'),
          VocabWord(urdu: 'پل', english: 'Bridge', pronunciation: 'Pul'),
          VocabWord(urdu: 'سڑک', english: 'Street', pronunciation: 'Sarak'),
          VocabWord(
            urdu: 'چوک',
            english: 'Intersection',
            pronunciation: 'Chowk',
          ),
          VocabWord(urdu: 'ٹکٹ', english: 'Ticket', pronunciation: 'Ticket'),
          VocabWord(urdu: 'کرایہ', english: 'Fare', pronunciation: 'Kiraya'),
          VocabWord(urdu: 'سامان', english: 'Luggage', pronunciation: 'Saman'),
          VocabWord(
            urdu: 'مسافر',
            english: 'Passenger',
            pronunciation: 'Musafir',
          ),
          VocabWord(
            urdu: 'ڈرائیور',
            english: 'Driver',
            pronunciation: 'Driver',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'دشاواں',
        words: [
          VocabWord(urdu: 'سجے', english: 'Right', pronunciation: 'Saje'),
          VocabWord(urdu: 'کھبے', english: 'Left', pronunciation: 'Khabbe'),
          VocabWord(urdu: 'سدھا', english: 'Straight', pronunciation: 'Sidha'),
          VocabWord(urdu: 'اتے', english: 'Up/Above', pronunciation: 'Utte'),
          VocabWord(
            urdu: 'تھلے',
            english: 'Down/Below',
            pronunciation: 'Thalle',
          ),
          VocabWord(
            urdu: 'ساہمنے',
            english: 'In front',
            pronunciation: 'Sahmne',
          ),
          VocabWord(urdu: 'پچھے', english: 'Behind', pronunciation: 'Pichhe'),
          VocabWord(urdu: 'نیڑے', english: 'Near', pronunciation: 'Nede'),
          VocabWord(urdu: 'دور', english: 'Far', pronunciation: 'Door'),
          VocabWord(urdu: 'اندر', english: 'Inside', pronunciation: 'Andar'),
          VocabWord(urdu: 'باہر', english: 'Outside', pronunciation: 'Bahar'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'سفری فقرے',
        words: [
          VocabWord(
            urdu: 'کتھے جا رہے او',
            english: 'Where are you going',
            pronunciation: 'Kithe ja rahe o',
          ),
          VocabWord(
            urdu: 'میں جا رہیا ں',
            english: 'I am going',
            pronunciation: 'Main ja reha aan',
          ),
          VocabWord(
            urdu: 'کنا ویلا لگے گا',
            english: 'How long will it take',
            pronunciation: 'Kinna vela lage ga',
          ),
          VocabWord(
            urdu: 'کنے پیسے',
            english: 'How much money',
            pronunciation: 'Kinne paise',
          ),
          VocabWord(
            urdu: 'رک جاؤ',
            english: 'Please stop',
            pronunciation: 'Ruk jao',
          ),
          VocabWord(
            urdu: 'اہستہ چلاؤ',
            english: 'Drive slowly',
            pronunciation: 'Ahista chalao',
          ),
          VocabWord(
            urdu: 'جلدی کرو',
            english: 'Hurry up',
            pronunciation: 'Jaldi karo',
          ),
          VocabWord(
            urdu: 'رستہ دسو',
            english: 'Show the way',
            pronunciation: 'Rasta dasso',
          ),
          VocabWord(
            urdu: 'میں کھو گیا ہاں',
            english: 'I am lost',
            pronunciation: 'Main kho gaya aan',
          ),
          VocabWord(
            urdu: 'مدد کرو',
            english: 'Please help',
            pronunciation: 'Madad karo',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'شہر دیاں چیزاں',
        words: [
          VocabWord(urdu: 'شہر', english: 'City', pronunciation: 'Sheher'),
          VocabWord(urdu: 'پنڈ', english: 'Village', pronunciation: 'Pind'),
          VocabWord(
            urdu: 'عمارت',
            english: 'Building',
            pronunciation: 'Imaarat',
          ),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukaan'),
          VocabWord(urdu: 'بینک', english: 'Bank', pronunciation: 'Bank'),
          VocabWord(
            urdu: 'ڈاک خانہ',
            english: 'Post Office',
            pronunciation: 'Daak khana',
          ),
          VocabWord(
            urdu: 'تھانہ',
            english: 'Police Station',
            pronunciation: 'Thana',
          ),
          VocabWord(
            urdu: 'میدان',
            english: 'Ground/Field',
            pronunciation: 'Maidan',
          ),
          VocabWord(urdu: 'باغ', english: 'Garden', pronunciation: 'Bagh'),
          VocabWord(urdu: 'چوک', english: 'Square', pronunciation: 'Chowk'),
          VocabWord(
            urdu: 'محلہ',
            english: 'Neighborhood',
            pronunciation: 'Mohalla',
          ),
        ],
      ),
    ],

    'punjabi_ch5': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'میوے',
        words: [
          VocabWord(urdu: 'سیب', english: 'Apple', pronunciation: 'Seb'),
          VocabWord(urdu: 'کیلا', english: 'Banana', pronunciation: 'Kela'),
          VocabWord(urdu: 'آم', english: 'Mango', pronunciation: 'Aam'),
          VocabWord(urdu: 'انگور', english: 'Grapes', pronunciation: 'Angoor'),
          VocabWord(urdu: 'مالٹا', english: 'Orange', pronunciation: 'Malta'),
          VocabWord(
            urdu: 'انار',
            english: 'Pomegranate',
            pronunciation: 'Anaar',
          ),
          VocabWord(
            urdu: 'ترما',
            english: 'Watermelon',
            pronunciation: 'Tarma',
          ),
          VocabWord(
            urdu: 'خربوزہ',
            english: 'Melon',
            pronunciation: 'Kharbooza',
          ),
          VocabWord(urdu: 'آڑو', english: 'Peach', pronunciation: 'Aaroo'),
          VocabWord(
            urdu: 'ناشپاتی',
            english: 'Pear',
            pronunciation: 'Nashpati',
          ),
          VocabWord(urdu: 'املی', english: 'Tamarind', pronunciation: 'Imli'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سبزیاں',
        words: [
          VocabWord(urdu: 'آلو', english: 'Potato', pronunciation: 'Aloo'),
          VocabWord(urdu: 'پیاز', english: 'Onion', pronunciation: 'Pyaz'),
          VocabWord(urdu: 'ٹماٹر', english: 'Tomato', pronunciation: 'Tamatar'),
          VocabWord(urdu: 'لسن', english: 'Garlic', pronunciation: 'Lassan'),
          VocabWord(urdu: 'ادرک', english: 'Ginger', pronunciation: 'Adrak'),
          VocabWord(urdu: 'مرچ', english: 'Chili', pronunciation: 'Mirch'),
          VocabWord(
            urdu: 'گوبھی',
            english: 'Cauliflower',
            pronunciation: 'Gobhi',
          ),
          VocabWord(
            urdu: 'بینگن',
            english: 'Eggplant',
            pronunciation: 'Baingan',
          ),
          VocabWord(urdu: 'گاجر', english: 'Carrot', pronunciation: 'Gajar'),
          VocabWord(urdu: 'مٹر', english: 'Peas', pronunciation: 'Matar'),
          VocabWord(urdu: 'پالک', english: 'Spinach', pronunciation: 'Palak'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'مصالحے',
        words: [
          VocabWord(urdu: 'لون', english: 'Salt', pronunciation: 'Loon'),
          VocabWord(
            urdu: 'کالی مرچ',
            english: 'Black Pepper',
            pronunciation: 'Kali mirch',
          ),
          VocabWord(
            urdu: 'لال مرچ',
            english: 'Red Chili',
            pronunciation: 'Laal mirch',
          ),
          VocabWord(urdu: 'ہلدی', english: 'Turmeric', pronunciation: 'Haldi'),
          VocabWord(
            urdu: 'دھنیا',
            english: 'Coriander',
            pronunciation: 'Dhaniya',
          ),
          VocabWord(urdu: 'زیرہ', english: 'Cumin', pronunciation: 'Zeera'),
          VocabWord(
            urdu: 'گرم مصالحہ',
            english: 'Garam Masala',
            pronunciation: 'Garam masala',
          ),
          VocabWord(
            urdu: 'دال چینی',
            english: 'Cinnamon',
            pronunciation: 'Daal cheeni',
          ),
          VocabWord(urdu: 'لونگ', english: 'Clove', pronunciation: 'Laung'),
          VocabWord(
            urdu: 'الائچی',
            english: 'Cardamom',
            pronunciation: 'Elaichi',
          ),
          VocabWord(urdu: 'تیل', english: 'Oil', pronunciation: 'Tel'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کھاݨ دیاں قسماں',
        words: [
          VocabWord(
            urdu: 'بریانی',
            english: 'Biryani',
            pronunciation: 'Biryani',
          ),
          VocabWord(urdu: 'قورمہ', english: 'Korma', pronunciation: 'Qorma'),
          VocabWord(urdu: 'کباب', english: 'Kebab', pronunciation: 'Kebab'),
          VocabWord(urdu: 'پلاؤ', english: 'Pulao', pronunciation: 'Pulao'),
          VocabWord(urdu: 'نان', english: 'Naan', pronunciation: 'Naan'),
          VocabWord(
            urdu: 'پراٹھا',
            english: 'Paratha',
            pronunciation: 'Paratha',
          ),
          VocabWord(urdu: 'سموسہ', english: 'Samosa', pronunciation: 'Samosa'),
          VocabWord(urdu: 'پکوڑا', english: 'Pakora', pronunciation: 'Pakora'),
          VocabWord(urdu: 'حلوہ', english: 'Halwa', pronunciation: 'Halwa'),
          VocabWord(
            urdu: 'کھیر',
            english: 'Rice pudding',
            pronunciation: 'Kheer',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'پکاون دے الفاظ',
        words: [
          VocabWord(
            urdu: 'پکاونا',
            english: 'To cook',
            pronunciation: 'Pakauna',
          ),
          VocabWord(urdu: 'بھننا', english: 'To fry', pronunciation: 'Bhunna'),
          VocabWord(
            urdu: 'ابالنا',
            english: 'To boil',
            pronunciation: 'Ubalna',
          ),
          VocabWord(urdu: 'کٹنا', english: 'To cut', pronunciation: 'Katna'),
          VocabWord(
            urdu: 'چھلنا',
            english: 'To peel',
            pronunciation: 'Chhilna',
          ),
          VocabWord(urdu: 'دھونا', english: 'To wash', pronunciation: 'Dhona'),
          VocabWord(urdu: 'رلانا', english: 'To mix', pronunciation: 'Ralana'),
          VocabWord(
            urdu: 'پیسنا',
            english: 'To grind',
            pronunciation: 'Peesna',
          ),
          VocabWord(
            urdu: 'چکھنا',
            english: 'To taste',
            pronunciation: 'Chakhna',
          ),
          VocabWord(urdu: 'چمچ', english: 'Spoon', pronunciation: 'Chamach'),
          VocabWord(urdu: 'کانٹا', english: 'Fork', pronunciation: 'Kanta'),
          VocabWord(urdu: 'چری', english: 'Knife', pronunciation: 'Churi'),
        ],
      ),
    ],

    'punjabi_ch6': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'صحت تے بیماری',
        words: [
          VocabWord(urdu: 'صحت', english: 'Health', pronunciation: 'Sehat'),
          VocabWord(
            urdu: 'بیماری',
            english: 'Illness',
            pronunciation: 'Bimari',
          ),
          VocabWord(urdu: 'بخار', english: 'Fever', pronunciation: 'Bukhar'),
          VocabWord(urdu: 'کھنگھ', english: 'Cough', pronunciation: 'Khangh'),
          VocabWord(urdu: 'زکام', english: 'Cold', pronunciation: 'Zukam'),
          VocabWord(
            urdu: 'سر درد',
            english: 'Headache',
            pronunciation: 'Sir dard',
          ),
          VocabWord(
            urdu: 'پیٹ درد',
            english: 'Stomachache',
            pronunciation: 'Pet dard',
          ),
          VocabWord(
            urdu: 'دند درد',
            english: 'Toothache',
            pronunciation: 'Dand dard',
          ),
          VocabWord(urdu: 'درد', english: 'Pain', pronunciation: 'Dard'),
          VocabWord(urdu: 'زخم', english: 'Wound', pronunciation: 'Zakham'),
          VocabWord(urdu: 'دوا', english: 'Medicine', pronunciation: 'Dawa'),
          VocabWord(urdu: 'ڈاکٹر', english: 'Doctor', pronunciation: 'Doctor'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'جسم دے ہور انگ',
        words: [
          VocabWord(urdu: 'گردن', english: 'Neck', pronunciation: 'Gardan'),
          VocabWord(urdu: 'موڈھا', english: 'Shoulder', pronunciation: 'Modha'),
          VocabWord(urdu: 'کونی', english: 'Elbow', pronunciation: 'Koni'),
          VocabWord(urdu: 'کلائی', english: 'Wrist', pronunciation: 'Kalai'),
          VocabWord(urdu: 'گوڈا', english: 'Knee', pronunciation: 'Goda'),
          VocabWord(urdu: 'ایڑی', english: 'Heel', pronunciation: 'Airi'),
          VocabWord(
            urdu: 'انگوٹھا',
            english: 'Thumb',
            pronunciation: 'Angutha',
          ),
          VocabWord(urdu: 'نخ', english: 'Nail', pronunciation: 'Nakh'),
          VocabWord(urdu: 'دل', english: 'Heart', pronunciation: 'Dil'),
          VocabWord(urdu: 'کلیجا', english: 'Liver', pronunciation: 'Kaleja'),
          VocabWord(urdu: 'گردے', english: 'Kidneys', pronunciation: 'Gurde'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'علاج تے دیکھ بھال',
        words: [
          VocabWord(urdu: 'علاج', english: 'Treatment', pronunciation: 'Ilaaj'),
          VocabWord(
            urdu: 'آپریشن',
            english: 'Operation',
            pronunciation: 'Operation',
          ),
          VocabWord(urdu: 'سوئی', english: 'Injection', pronunciation: 'Sooi'),
          VocabWord(urdu: 'گولی', english: 'Pill', pronunciation: 'Goli'),
          VocabWord(urdu: 'شربت', english: 'Syrup', pronunciation: 'Sharbat'),
          VocabWord(urdu: 'مرہم', english: 'Ointment', pronunciation: 'Marham'),
          VocabWord(urdu: 'پٹی', english: 'Bandage', pronunciation: 'Patti'),
          VocabWord(urdu: 'نرس', english: 'Nurse', pronunciation: 'Nurse'),
          VocabWord(urdu: 'مریض', english: 'Patient', pronunciation: 'Mareez'),
          VocabWord(urdu: 'پلنگ', english: 'Bed', pronunciation: 'Palang'),
          VocabWord(urdu: 'ٹیسٹ', english: 'Test', pronunciation: 'Test'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'صحت دے فقرے',
        words: [
          VocabWord(
            urdu: 'میں بیمار آں',
            english: 'I am sick',
            pronunciation: 'Main bimar aan',
          ),
          VocabWord(
            urdu: 'مینوں بخار اے',
            english: 'I have fever',
            pronunciation: 'Mainu bukhar ae',
          ),
          VocabWord(
            urdu: 'مینوں درد اے',
            english: 'I have pain',
            pronunciation: 'Mainu dard ae',
          ),
          VocabWord(
            urdu: 'آرام کرو',
            english: 'Take rest',
            pronunciation: 'Aaraam karo',
          ),
          VocabWord(
            urdu: 'دوا لو',
            english: 'Take medicine',
            pronunciation: 'Dawa lo',
          ),
          VocabWord(
            urdu: 'پانی پیو',
            english: 'Drink water',
            pronunciation: 'Pani pio',
          ),
          VocabWord(
            urdu: 'چنگی صحت',
            english: 'Good health',
            pronunciation: 'Changi sehat',
          ),
          VocabWord(
            urdu: 'جلدی ٹھیک ہو',
            english: 'Get well soon',
            pronunciation: 'Jaldi theek ho',
          ),
          VocabWord(
            urdu: 'کی تکلیف اے',
            english: 'What is the problem',
            pronunciation: 'Ki takleef ae',
          ),
          VocabWord(
            urdu: 'ڈاکٹر نوں ویکھو',
            english: 'Show to doctor',
            pronunciation: 'Doctor nu veikho',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'ورزش تے فٹنس',
        words: [
          VocabWord(
            urdu: 'ورزش',
            english: 'Exercise',
            pronunciation: 'Warzish',
          ),
          VocabWord(urdu: 'دوڑنا', english: 'To run', pronunciation: 'Daurna'),
          VocabWord(urdu: 'تریڑنا', english: 'To walk', pronunciation: 'Turna'),
          VocabWord(urdu: 'تریݨا', english: 'To swim', pronunciation: 'Tairnا'),
          VocabWord(
            urdu: 'کھیڈنا',
            english: 'To play',
            pronunciation: 'Khedna',
          ),
          VocabWord(urdu: 'یوگا', english: 'Yoga', pronunciation: 'Yoga'),
          VocabWord(urdu: 'جم', english: 'Gym', pronunciation: 'Gym'),
          VocabWord(urdu: 'طاقت', english: 'Strength', pronunciation: 'Taaqat'),
          VocabWord(
            urdu: 'توانائی',
            english: 'Energy',
            pronunciation: 'Tawanai',
          ),
          VocabWord(
            urdu: 'تھکاوٹ',
            english: 'Tiredness',
            pronunciation: 'Thakawat',
          ),
          VocabWord(
            urdu: 'تندرست',
            english: 'Healthy',
            pronunciation: 'Tandurust',
          ),
        ],
      ),
    ],

    'punjabi_ch7': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'پڑھائی',
        words: [
          VocabWord(
            urdu: 'پڑھائی',
            english: 'Education',
            pronunciation: 'Parhai',
          ),
          VocabWord(urdu: 'استاد', english: 'Teacher', pronunciation: 'Ustad'),
          VocabWord(
            urdu: 'شاگرد',
            english: 'Student',
            pronunciation: 'Shagird',
          ),
          VocabWord(urdu: 'کلاس', english: 'Class', pronunciation: 'Class'),
          VocabWord(urdu: 'امتحان', english: 'Exam', pronunciation: 'Imtihan'),
          VocabWord(urdu: 'نتیجہ', english: 'Result', pronunciation: 'Nateeja'),
          VocabWord(urdu: 'نمبر', english: 'Marks', pronunciation: 'Number'),
          VocabWord(
            urdu: 'کامیابی',
            english: 'Success',
            pronunciation: 'Kamyabi',
          ),
          VocabWord(
            urdu: 'ناکامی',
            english: 'Failure',
            pronunciation: 'Nakkami',
          ),
          VocabWord(
            urdu: 'ہوم ورک',
            english: 'Homework',
            pronunciation: 'Homework',
          ),
          VocabWord(urdu: 'سبق', english: 'Lesson', pronunciation: 'Sabaq'),
          VocabWord(urdu: 'علم', english: 'Knowledge', pronunciation: 'Ilm'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سکول دیاں چیزاں',
        words: [
          VocabWord(
            urdu: 'بلیک بورڈ',
            english: 'Blackboard',
            pronunciation: 'Blackboard',
          ),
          VocabWord(urdu: 'چاک', english: 'Chalk', pronunciation: 'Chalk'),
          VocabWord(urdu: 'ربڑ', english: 'Eraser', pronunciation: 'Rubber'),
          VocabWord(urdu: 'پنسل', english: 'Pencil', pronunciation: 'Pencil'),
          VocabWord(urdu: 'پٹڑی', english: 'Ruler', pronunciation: 'Patri'),
          VocabWord(urdu: 'کتاباں', english: 'Books', pronunciation: 'Kitaban'),
          VocabWord(
            urdu: 'کاپیاں',
            english: 'Notebooks',
            pronunciation: 'Kopiyan',
          ),
          VocabWord(
            urdu: 'بستہ',
            english: 'School bag',
            pronunciation: 'Basta',
          ),
          VocabWord(urdu: 'میز', english: 'Table', pronunciation: 'Maiz'),
          VocabWord(urdu: 'کرسی', english: 'Chair', pronunciation: 'Kursi'),
          VocabWord(
            urdu: 'الماری',
            english: 'Cupboard',
            pronunciation: 'Almari',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'ورے',
        words: [
          VocabWord(
            urdu: 'ریاضی',
            english: 'Mathematics',
            pronunciation: 'Riyazi',
          ),
          VocabWord(
            urdu: 'سائنس',
            english: 'Science',
            pronunciation: 'Science',
          ),
          VocabWord(
            urdu: 'انگریزی',
            english: 'English',
            pronunciation: 'English',
          ),
          VocabWord(
            urdu: 'پنجابی',
            english: 'Punjabi',
            pronunciation: 'Punjabi',
          ),
          VocabWord(
            urdu: 'اسلامیات',
            english: 'Islamic Studies',
            pronunciation: 'Islamiyat',
          ),
          VocabWord(
            urdu: 'سماجی علوم',
            english: 'Social Studies',
            pronunciation: 'Samaji uloom',
          ),
          VocabWord(
            urdu: 'جغرافیہ',
            english: 'Geography',
            pronunciation: 'Jughrafiya',
          ),
          VocabWord(urdu: 'تریخ', english: 'History', pronunciation: 'Tarekh'),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'تصویر',
            english: 'Drawing',
            pronunciation: 'Tasveer',
          ),
          VocabWord(urdu: 'کھیڈ', english: 'Sports', pronunciation: 'Khed'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'پڑھائی دے الفاظ',
        words: [
          VocabWord(
            urdu: 'سکھنا',
            english: 'To learn',
            pronunciation: 'Sikhna',
          ),
          VocabWord(urdu: 'پڑھنا', english: 'To read', pronunciation: 'Parhna'),
          VocabWord(
            urdu: 'لکھنا',
            english: 'To write',
            pronunciation: 'Likhna',
          ),
          VocabWord(
            urdu: 'سمجھنا',
            english: 'To understand',
            pronunciation: 'Samajhna',
          ),
          VocabWord(
            urdu: 'یاد کرنا',
            english: 'To memorize',
            pronunciation: 'Yaad karna',
          ),
          VocabWord(
            urdu: 'دہرانا',
            english: 'To repeat',
            pronunciation: 'Dohrana',
          ),
          VocabWord(
            urdu: 'حل کرنا',
            english: 'To solve',
            pronunciation: 'Hal karna',
          ),
          VocabWord(
            urdu: 'جواب دینا',
            english: 'To answer',
            pronunciation: 'Jawab dena',
          ),
          VocabWord(
            urdu: 'سوال پچھنا',
            english: 'To ask question',
            pronunciation: 'Sawal puchhna',
          ),
          VocabWord(
            urdu: 'سمجھانا',
            english: 'To explain',
            pronunciation: 'Samjhana',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'یونیورسٹی',
        words: [
          VocabWord(
            urdu: 'یونیورسٹی',
            english: 'University',
            pronunciation: 'University',
          ),
          VocabWord(urdu: 'کالج', english: 'College', pronunciation: 'College'),
          VocabWord(urdu: 'ڈگری', english: 'Degree', pronunciation: 'Degree'),
          VocabWord(
            urdu: 'پروفیسر',
            english: 'Professor',
            pronunciation: 'Professor',
          ),
          VocabWord(
            urdu: 'لیکچر',
            english: 'Lecture',
            pronunciation: 'Lecture',
          ),
          VocabWord(
            urdu: 'تحقیق',
            english: 'Research',
            pronunciation: 'Tahqeeq',
          ),
          VocabWord(
            urdu: 'اسکالرشپ',
            english: 'Scholarship',
            pronunciation: 'Scholarship',
          ),
          VocabWord(
            urdu: 'سرٹیفکیٹ',
            english: 'Certificate',
            pronunciation: 'Certificate',
          ),
          VocabWord(
            urdu: 'داخلہ',
            english: 'Admission',
            pronunciation: 'Dakhila',
          ),
          VocabWord(urdu: 'فیس', english: 'Fee', pronunciation: 'Fee'),
        ],
      ),
    ],

    'punjabi_ch8': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'پیشے',
        words: [
          VocabWord(urdu: 'ڈاکٹر', english: 'Doctor', pronunciation: 'Doctor'),
          VocabWord(
            urdu: 'انجینئر',
            english: 'Engineer',
            pronunciation: 'Engineer',
          ),
          VocabWord(urdu: 'وکیل', english: 'Lawyer', pronunciation: 'Vakeel'),
          VocabWord(urdu: 'استاد', english: 'Teacher', pronunciation: 'Ustad'),
          VocabWord(urdu: 'پائلٹ', english: 'Pilot', pronunciation: 'Pilot'),
          VocabWord(urdu: 'پولیس', english: 'Police', pronunciation: 'Police'),
          VocabWord(urdu: 'سپاہی', english: 'Soldier', pronunciation: 'Sipahi'),
          VocabWord(urdu: 'کسان', english: 'Farmer', pronunciation: 'Kisaan'),
          VocabWord(
            urdu: 'تاجر',
            english: 'Businessman',
            pronunciation: 'Tajir',
          ),
          VocabWord(
            urdu: 'سیلز مین',
            english: 'Salesman',
            pronunciation: 'Salesman',
          ),
          VocabWord(
            urdu: 'اکاؤنٹنٹ',
            english: 'Accountant',
            pronunciation: 'Accountant',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'دفتر دے الفاظ',
        words: [
          VocabWord(urdu: 'دفتر', english: 'Office', pronunciation: 'Daftar'),
          VocabWord(
            urdu: 'ملازم',
            english: 'Employee',
            pronunciation: 'Mulazim',
          ),
          VocabWord(urdu: 'مالک', english: 'Owner', pronunciation: 'Malik'),
          VocabWord(
            urdu: 'منیجر',
            english: 'Manager',
            pronunciation: 'Manager',
          ),
          VocabWord(
            urdu: 'سکریٹری',
            english: 'Secretary',
            pronunciation: 'Secretary',
          ),
          VocabWord(
            urdu: 'میٹنگ',
            english: 'Meeting',
            pronunciation: 'Meeting',
          ),
          VocabWord(urdu: 'رپورٹ', english: 'Report', pronunciation: 'Report'),
          VocabWord(urdu: 'فائل', english: 'File', pronunciation: 'File'),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'پرنٹر',
            english: 'Printer',
            pronunciation: 'Printer',
          ),
          VocabWord(urdu: 'فون', english: 'Phone', pronunciation: 'Phone'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'کم دے الفاظ',
        words: [
          VocabWord(urdu: 'کم', english: 'Work', pronunciation: 'Kam'),
          VocabWord(urdu: 'نوکری', english: 'Job', pronunciation: 'Naukri'),
          VocabWord(
            urdu: 'تنخواہ',
            english: 'Salary',
            pronunciation: 'Tankhwah',
          ),
          VocabWord(urdu: 'چھٹی', english: 'Leave', pronunciation: 'Chutti'),
          VocabWord(
            urdu: 'حاضری',
            english: 'Attendance',
            pronunciation: 'Hazri',
          ),
          VocabWord(urdu: 'ویلا', english: 'Time', pronunciation: 'Vela'),
          VocabWord(urdu: 'ٹارگٹ', english: 'Target', pronunciation: 'Target'),
          VocabWord(
            urdu: 'پروجیکٹ',
            english: 'Project',
            pronunciation: 'Project',
          ),
          VocabWord(urdu: 'ٹیم', english: 'Team', pronunciation: 'Team'),
          VocabWord(
            urdu: 'ترقی',
            english: 'Promotion',
            pronunciation: 'Taraqi',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کاروبار',
        words: [
          VocabWord(
            urdu: 'کاروبار',
            english: 'Business',
            pronunciation: 'Karobar',
          ),
          VocabWord(urdu: 'دکان', english: 'Shop', pronunciation: 'Dukaan'),
          VocabWord(urdu: 'گاہک', english: 'Customer', pronunciation: 'Gahak'),
          VocabWord(
            urdu: 'خریدنا',
            english: 'To buy',
            pronunciation: 'Khareedna',
          ),
          VocabWord(
            urdu: 'ویچنا',
            english: 'To sell',
            pronunciation: 'Vaichna',
          ),
          VocabWord(urdu: 'قیمت', english: 'Price', pronunciation: 'Qeemat'),
          VocabWord(urdu: 'فائدہ', english: 'Profit', pronunciation: 'Faida'),
          VocabWord(urdu: 'نقصان', english: 'Loss', pronunciation: 'Nuqsan'),
          VocabWord(urdu: 'سودا', english: 'Deal', pronunciation: 'Sauda'),
          VocabWord(
            urdu: 'اشتہار',
            english: 'Advertisement',
            pronunciation: 'Ishtahar',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'کم دے فقرے',
        words: [
          VocabWord(
            urdu: 'میں کم کردا ں',
            english: 'I work',
            pronunciation: 'Main kam karda aan',
          ),
          VocabWord(
            urdu: 'میری نوکری اے',
            english: 'I have a job',
            pronunciation: 'Meri naukri ae',
          ),
          VocabWord(
            urdu: 'دفتر جانا اے',
            english: 'Have to go to office',
            pronunciation: 'Daftar jana ae',
          ),
          VocabWord(
            urdu: 'کم مکمل ہویا',
            english: 'Work completed',
            pronunciation: 'Kam mukammal hoya',
          ),
          VocabWord(
            urdu: 'چھٹی چاہیدی',
            english: 'Need leave',
            pronunciation: 'Chutti chaheedi',
          ),
          VocabWord(
            urdu: 'بوہت کم اے',
            english: 'Lot of work',
            pronunciation: 'Bohat kam ae',
          ),
          VocabWord(
            urdu: 'مصروف آں',
            english: 'I am busy',
            pronunciation: 'Masroof aan',
          ),
          VocabWord(
            urdu: 'فارغ آں',
            english: 'I am free',
            pronunciation: 'Farigh aan',
          ),
          VocabWord(
            urdu: 'میٹنگ اے',
            english: 'There is a meeting',
            pronunciation: 'Meeting ae',
          ),
          VocabWord(
            urdu: 'تنخواہ ملی',
            english: 'Got salary',
            pronunciation: 'Tankhwah mili',
          ),
        ],
      ),
    ],

    'punjabi_ch9': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'ٹیکنالوجی',
        words: [
          VocabWord(urdu: 'موبائل', english: 'Mobile', pronunciation: 'Mobile'),
          VocabWord(
            urdu: 'لیپ ٹاپ',
            english: 'Laptop',
            pronunciation: 'Laptop',
          ),
          VocabWord(
            urdu: 'کمپیوٹر',
            english: 'Computer',
            pronunciation: 'Computer',
          ),
          VocabWord(
            urdu: 'انٹرنیٹ',
            english: 'Internet',
            pronunciation: 'Internet',
          ),
          VocabWord(
            urdu: 'ویب سائٹ',
            english: 'Website',
            pronunciation: 'Website',
          ),
          VocabWord(urdu: 'ایپ', english: 'App', pronunciation: 'App'),
          VocabWord(
            urdu: 'سوفٹ ویئر',
            english: 'Software',
            pronunciation: 'Software',
          ),
          VocabWord(
            urdu: 'کی بورڈ',
            english: 'Keyboard',
            pronunciation: 'Keyboard',
          ),
          VocabWord(urdu: 'ماؤس', english: 'Mouse', pronunciation: 'Mouse'),
          VocabWord(urdu: 'اسکرین', english: 'Screen', pronunciation: 'Screen'),
          VocabWord(
            urdu: 'چارجر',
            english: 'Charger',
            pronunciation: 'Charger',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'سوشل میڈیا',
        words: [
          VocabWord(
            urdu: 'سوشل میڈیا',
            english: 'Social media',
            pronunciation: 'Social media',
          ),
          VocabWord(
            urdu: 'فیس بک',
            english: 'Facebook',
            pronunciation: 'Facebook',
          ),
          VocabWord(
            urdu: 'واٹس ایپ',
            english: 'WhatsApp',
            pronunciation: 'WhatsApp',
          ),
          VocabWord(
            urdu: 'انسٹاگرام',
            english: 'Instagram',
            pronunciation: 'Instagram',
          ),
          VocabWord(
            urdu: 'یوٹیوب',
            english: 'YouTube',
            pronunciation: 'YouTube',
          ),
          VocabWord(urdu: 'پوسٹ', english: 'Post', pronunciation: 'Post'),
          VocabWord(urdu: 'لائک', english: 'Like', pronunciation: 'Like'),
          VocabWord(urdu: 'شیئر', english: 'Share', pronunciation: 'Share'),
          VocabWord(urdu: 'کمنٹ', english: 'Comment', pronunciation: 'Comment'),
          VocabWord(urdu: 'فالو', english: 'Follow', pronunciation: 'Follow'),
          VocabWord(urdu: 'میسج', english: 'Message', pronunciation: 'Message'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'الیکٹرانکس',
        words: [
          VocabWord(urdu: 'ٹی وی', english: 'TV', pronunciation: 'TV'),
          VocabWord(urdu: 'ریڈیو', english: 'Radio', pronunciation: 'Radio'),
          VocabWord(urdu: 'کیمرہ', english: 'Camera', pronunciation: 'Camera'),
          VocabWord(urdu: 'ریموٹ', english: 'Remote', pronunciation: 'Remote'),
          VocabWord(
            urdu: 'بیٹری',
            english: 'Battery',
            pronunciation: 'Battery',
          ),
          VocabWord(
            urdu: 'بجلی',
            english: 'Electricity',
            pronunciation: 'Bijli',
          ),
          VocabWord(urdu: 'سوئچ', english: 'Switch', pronunciation: 'Switch'),
          VocabWord(urdu: 'پلگ', english: 'Plug', pronunciation: 'Plug'),
          VocabWord(urdu: 'تار', english: 'Wire', pronunciation: 'Taar'),
          VocabWord(
            urdu: 'ہیڈ فون',
            english: 'Headphones',
            pronunciation: 'Headphone',
          ),
          VocabWord(
            urdu: 'سپیکر',
            english: 'Speaker',
            pronunciation: 'Speaker',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'کمپیوٹر دے الفاظ',
        words: [
          VocabWord(urdu: 'فائل', english: 'File', pronunciation: 'File'),
          VocabWord(urdu: 'فولڈر', english: 'Folder', pronunciation: 'Folder'),
          VocabWord(
            urdu: 'ڈاؤن لوڈ',
            english: 'Download',
            pronunciation: 'Download',
          ),
          VocabWord(urdu: 'اپ لوڈ', english: 'Upload', pronunciation: 'Upload'),
          VocabWord(urdu: 'سیو', english: 'Save', pronunciation: 'Save'),
          VocabWord(urdu: 'ڈیلیٹ', english: 'Delete', pronunciation: 'Delete'),
          VocabWord(urdu: 'کاپی', english: 'Copy', pronunciation: 'Copy'),
          VocabWord(urdu: 'پیسٹ', english: 'Paste', pronunciation: 'Paste'),
          VocabWord(urdu: 'پرنٹ', english: 'Print', pronunciation: 'Print'),
          VocabWord(
            urdu: 'پاس ورڈ',
            english: 'Password',
            pronunciation: 'Password',
          ),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'جدید زندگی',
        words: [
          VocabWord(urdu: 'اے ٹی ایم', english: 'ATM', pronunciation: 'ATM'),
          VocabWord(
            urdu: 'کریڈٹ کارڈ',
            english: 'Credit card',
            pronunciation: 'Credit card',
          ),
          VocabWord(
            urdu: 'آن لائن',
            english: 'Online',
            pronunciation: 'Online',
          ),
          VocabWord(
            urdu: 'آف لائن',
            english: 'Offline',
            pronunciation: 'Offline',
          ),
          VocabWord(
            urdu: 'شاپنگ',
            english: 'Shopping',
            pronunciation: 'Shopping',
          ),
          VocabWord(
            urdu: 'ڈلیوری',
            english: 'Delivery',
            pronunciation: 'Delivery',
          ),
          VocabWord(urdu: 'آرڈر', english: 'Order', pronunciation: 'Order'),
          VocabWord(
            urdu: 'پیمنٹ',
            english: 'Payment',
            pronunciation: 'Payment',
          ),
          VocabWord(
            urdu: 'اکاؤنٹ',
            english: 'Account',
            pronunciation: 'Account',
          ),
          VocabWord(urdu: 'سروس', english: 'Service', pronunciation: 'Service'),
        ],
      ),
    ],

    'punjabi_ch10': [
      LessonVocabulary(
        lessonNumber: 1,
        title: 'مذہب',
        words: [
          VocabWord(urdu: 'اسلام', english: 'Islam', pronunciation: 'Islam'),
          VocabWord(
            urdu: 'مسلمان',
            english: 'Muslim',
            pronunciation: 'Musalman',
          ),
          VocabWord(urdu: 'اللہ', english: 'Allah', pronunciation: 'Allah'),
          VocabWord(urdu: 'نماز', english: 'Prayer', pronunciation: 'Namaz'),
          VocabWord(urdu: 'روزہ', english: 'Fast', pronunciation: 'Roza'),
          VocabWord(urdu: 'زکوٰۃ', english: 'Zakat', pronunciation: 'Zakat'),
          VocabWord(urdu: 'حج', english: 'Hajj', pronunciation: 'Hajj'),
          VocabWord(urdu: 'قرآن', english: 'Quran', pronunciation: 'Quran'),
          VocabWord(urdu: 'مسیت', english: 'Mosque', pronunciation: 'Masjid'),
          VocabWord(urdu: 'امام', english: 'Imam', pronunciation: 'Imam'),
          VocabWord(urdu: 'ایمان', english: 'Faith', pronunciation: 'Iman'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 2,
        title: 'تہوار',
        words: [
          VocabWord(urdu: 'عید', english: 'Eid', pronunciation: 'Eid'),
          VocabWord(
            urdu: 'عید الفطر',
            english: 'Eid ul-Fitr',
            pronunciation: 'Eid ul-Fitr',
          ),
          VocabWord(
            urdu: 'عید الاضحی',
            english: 'Eid ul-Adha',
            pronunciation: 'Eid ul-Adha',
          ),
          VocabWord(urdu: 'رمضان', english: 'Ramadan', pronunciation: 'Ramzan'),
          VocabWord(
            urdu: 'محرم',
            english: 'Muharram',
            pronunciation: 'Muharram',
          ),
          VocabWord(urdu: 'میلاد', english: 'Milad', pronunciation: 'Milad'),
          VocabWord(
            urdu: 'شب برات',
            english: 'Shab-e-Barat',
            pronunciation: 'Shab-e-Barat',
          ),
          VocabWord(
            urdu: 'قربانی',
            english: 'Sacrifice',
            pronunciation: 'Qurbani',
          ),
          VocabWord(urdu: 'صدقہ', english: 'Charity', pronunciation: 'Sadqa'),
          VocabWord(urdu: 'دعا', english: 'Prayer', pronunciation: 'Dua'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 3,
        title: 'ثقافت',
        words: [
          VocabWord(
            urdu: 'ثقافت',
            english: 'Culture',
            pronunciation: 'Saqafat',
          ),
          VocabWord(
            urdu: 'روایت',
            english: 'Tradition',
            pronunciation: 'Riwayat',
          ),
          VocabWord(urdu: 'رسم', english: 'Custom', pronunciation: 'Rasm'),
          VocabWord(urdu: 'شادی', english: 'Wedding', pronunciation: 'Shaadi'),
          VocabWord(urdu: 'لاڑا', english: 'Groom', pronunciation: 'Lara'),
          VocabWord(urdu: 'لاڑی', english: 'Bride', pronunciation: 'Lari'),
          VocabWord(urdu: 'مہندی', english: 'Mehndi', pronunciation: 'Mehndi'),
          VocabWord(urdu: 'برات', english: 'Baraat', pronunciation: 'Baraat'),
          VocabWord(urdu: 'ولیمہ', english: 'Walima', pronunciation: 'Walima'),
          VocabWord(urdu: 'تحفہ', english: 'Gift', pronunciation: 'Tohfa'),
          VocabWord(urdu: 'دعوت', english: 'Feast', pronunciation: 'Dawat'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 4,
        title: 'آداب',
        words: [
          VocabWord(urdu: 'ادب', english: 'Respect', pronunciation: 'Adab'),
          VocabWord(urdu: 'احترام', english: 'Honor', pronunciation: 'Ehteram'),
          VocabWord(urdu: 'سلام', english: 'Greeting', pronunciation: 'Salam'),
          VocabWord(urdu: 'شکر', english: 'Thanks', pronunciation: 'Shukar'),
          VocabWord(urdu: 'معافی', english: 'Apology', pronunciation: 'Maafi'),
          VocabWord(urdu: 'مہمان', english: 'Guest', pronunciation: 'Mehman'),
          VocabWord(urdu: 'میزبان', english: 'Host', pronunciation: 'Mezbaan'),
          VocabWord(
            urdu: 'مہمان نوازی',
            english: 'Hospitality',
            pronunciation: 'Mehman nawazi',
          ),
          VocabWord(urdu: 'عزت', english: 'Dignity', pronunciation: 'Izzat'),
          VocabWord(urdu: 'سچائی', english: 'Truth', pronunciation: 'Sachai'),
        ],
      ),
      LessonVocabulary(
        lessonNumber: 5,
        title: 'پاکستانی ثقافت',
        words: [
          VocabWord(
            urdu: 'پاکستان',
            english: 'Pakistan',
            pronunciation: 'Pakistan',
          ),
          VocabWord(
            urdu: 'قومی ترانہ',
            english: 'National anthem',
            pronunciation: 'Qaumi tarana',
          ),
          VocabWord(urdu: 'جھنڈا', english: 'Flag', pronunciation: 'Jhanda'),
          VocabWord(urdu: 'ہلال', english: 'Crescent', pronunciation: 'Hilal'),
          VocabWord(urdu: 'تارہ', english: 'Star', pronunciation: 'Tara'),
          VocabWord(urdu: 'سبز', english: 'Green', pronunciation: 'Sabz'),
          VocabWord(urdu: 'چٹا', english: 'White', pronunciation: 'Chitta'),
          VocabWord(
            urdu: 'یوم آزادی',
            english: 'Independence Day',
            pronunciation: 'Youm-e-Azadi',
          ),
          VocabWord(
            urdu: 'یوم پاکستان',
            english: 'Pakistan Day',
            pronunciation: 'Youm-e-Pakistan',
          ),
          VocabWord(
            urdu: 'قائد اعظم',
            english: 'Quaid-e-Azam',
            pronunciation: 'Quaid-e-Azam',
          ),
        ],
      ),
    ],
  };
}
