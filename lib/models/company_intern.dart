class CompanyIntern {
  String id;
  String logo;
  String name;
  String position;
  double salary;
  String location;
  CompanyDetail companyDetail;
  String? idUserCanBo;

  CompanyIntern(
    this.id,
    this.logo,
    this.name,
    this.position,
    this.salary,
    this.location,
    this.companyDetail,
    this.idUserCanBo,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logo': logo,
      'name': name,
      'position': position,
      'salary': salary,
      'location': location,
      'companyDetail': companyDetail.toMap(),
      'idUserCanBo': idUserCanBo
    };
  }

  factory CompanyIntern.fromMap(Map<String, dynamic> map) {
    return CompanyIntern(
      map['id'],
      map['logo'],
      map['name'],
      map['position'],
      map['salary'],
      map['location'],
      CompanyDetail.fromMap(map['companyDetail']),
      map['idUserCanBo'],
    );
  }
}

class CompanyDetail {
  String internshipPosition;
  String internshipDuration;
  String benefits;
  String applicationMethod;
  String address;

  CompanyDetail({
    required this.internshipPosition,
    required this.internshipDuration,
    required this.benefits,
    required this.applicationMethod,
    required this.address,
  });

  // Phương thức để chuyển đối tượng thành một Map
  Map<String, dynamic> toMap() {
    return {
      'internshipPosition': internshipPosition,
      'internshipDuration': internshipDuration,
      'benefits': benefits,
      'applicationMethod': applicationMethod,
      'address': address,
    };
  }

  // Phương thức tạo đối tượng từ một Map
  factory CompanyDetail.fromMap(Map<String, dynamic> map) {
    return CompanyDetail(
        internshipPosition: map['internshipPosition'],
        internshipDuration: map['internshipDuration'],
        benefits: map['benefits'],
        applicationMethod: map['applicationMethod'],
        address: map['address']);
  }
}

List<CompanyIntern> companies = [
  CompanyIntern(
      '01',
      'https://itviec.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL3F6SXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--87584e37110f284429335454942adf9a1e133d0d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdCem9MWm05eWJXRjBPZ2wzWldKd09oSnlaWE5wZW1WZmRHOWZabWwwV3dkcEFhb3ciLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--bb0ebae071595ab1791dc0ad640ef70a76504047/Purple%202.png',
      'Công ty Silicon Stack Việt Nam',
      'Thực tập sinh: Backend, Frontend, Mobile',
      2000000,
      'TP Hồ Chí Minh',
      companyDetail1,
      ''),
  CompanyIntern(
      '02',
      'https://media.licdn.com/dms/image/C4E0BAQGhTbNRDPDePg/company-logo_200_200/0/1519873351874?e=1704326400&v=beta&t=W23Dw7mz86OTSrI0bpam6R-Cl5trCJ1fn9TMurTirCc',
      'Công ty TNHH Techbase Việt Nam',
      'Thực tập sinh',
      5000000,
      'TP Hồ Chí Minh',
      companyDetailTechbase,
      ''),
  CompanyIntern(
      '03',
      'https://cdn-new.topcv.vn/unsafe/140x/filters:format(webp)/https://static.topcv.vn/company_logos/drimaes-vn-6316eb0d809b7.jpg',
      'Công ty PRIMAES',
      'Thực tập sinh: Backend (NodeJS), Frontend (ReactJS), Mobile (Flutter)',
      3000000,
      'TP Cần Thơ',
      companyDetailPRIMAES,
      ''),
  CompanyIntern(
      '04',
      'https://scontent-hkg4-1.xx.fbcdn.net/v/t39.30808-6/283092678_2090494587821782_8679712818922177375_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=a2f6c7&_nc_ohc=AXnNhm2gnhIAX8ewwsE&_nc_ht=scontent-hkg4-1.xx&oh=00_AfALVO4xrZu4WZxcMUgQ2lkP9on_1YhBT6dqvi4gJonpiw&oe=6523592F',
      'Công ty cổ phần phần mềm PATSOFT',
      'Thực tập sinh',
      1,
      'TP Cần Thơ',
      companyDetailPATSOFT,
      ''),
  CompanyIntern(
      '05',
      'https://www.tma.vn/Themes/TMAVN.Theme/Images/TMA-logo2.png',
      'Tập đoàn công nghệ TMA',
      'Tester, Backend, Frontend, Fullstack, Mobile, UX/UI Designer',
      5000000,
      'TP Hồ Chí Minh',
      companyDetail1,
      '0he8Ib5cP4YqrEciWtBu3221kU03'),
  CompanyIntern(
      '06',
      'https://arena.cusc.vn/logo_cusc.png',
      'Trung Tâm Công Nghệ Phần Mềm CUSC',
      'Thực tập sinh: Tester, Backend, Frontend',
      1,
      'TP Cần Thơ',
      companyDetail1,
      ''),
];

CompanyDetail companyDetail1 = CompanyDetail(
    applicationMethod: 'Sinh viên liên hệ trực tiếp qua email: job@abc.com',
    benefits:
        '- Môi trường làm việc năng động, chuyên nghiệp, sáng tạo\n- Được hỗ trợ 2.000.000 VND/ tháng\n- Được đào tạo, hướng dẫn công việc\n- Được khen thưởng nếu đạt thành tích cao trong quá trình thực tập\n- Sau khi hoàn thành chương trình thực tập, sinh viên thực tập có cơ hội được tiếp nhận làm việc chính thức tại Silicon Stack',
    internshipDuration: 'Theo lịch của nhà trường từ thứ 2 đến thứ 6 hàng tuần',
    internshipPosition:
        '- Backend: .NET/ Node.js\n- Frontend: ReactJS, Angular, Vue.js\n- Mobile: Android, iOS',
    address:
        'Tầng 5, Tòa nhà PN Co, 82 Trần Huy Liệu, Phường 15, Quận Phú Nhuận, TP.HCM, Việt Nam​');
CompanyDetail companyDetailTechbase = CompanyDetail(
    applicationMethod:
        'Bước 1: Điền thông tin https://forms.gle/zBRQi8ceqHuz6Eao6 hoặc quét QR CODE trên hình đính kèm\n- Bước 2: Nhận CV và bảng điểm đến hết ngày 16/03/2023 (kết quả screen CV và lịchphỏng vấn sẽ phản hồi qua email)\nTiêu đề email: [TBV SUMMER INTERNSHIP 2023_HỌ VÀ TÊN]\nEmail: recruiting@techbasevn.com\nPhone: (028)-3825-1649 (Ms. Duyên)',
    benefits:
        '- Trợ cấp thực tập 5.000.000 VND/tháng\n- Chi phí gửi xe hàng tháng\n- Cơ hội thành nhân viên chính thức với nhiều benefit hấp dẫn (Link tham khảo:www.techbase.com)',
    internshipDuration:
        '- Dự kiến bắt đầu từ 05/2023~07/2023\n- Thời gian làm việc: 8h – 17h, từ thứ Hai đến thứ Sáu',
    internshipPosition:
        'Sinh viên ngành CNTT mới tốt nghiệp hoặc sinh viên năm 4 có thể thực tập full time (Ưu tiên các bạn có thể đi làm được ngay sau kỳ thực tập)',
    address:
        'Công ty Techbase Việt Nam - Lầu 10, Tháp 2, Tòa nhà Saigon Centre, 67 Lê Lợi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh');
CompanyDetail companyDetailPATSOFT = CompanyDetail(
    applicationMethod:
        'Hồ sơ đăng ký:\n. Đơn đăng ký tập sự;\n. Thẻ sinh viên và Chứng minh thư;\n. Sơ yếu lý lịch;\n. Bảng điểm (có xác nhận của nhà trường).\nHình thức đăng ký: Nộp hồ sơ trực tiếp tại văn phòng Cần Thơ hoặc thông qua địa chỉ mail: info(@patsoft.com.vn',
    benefits:
        'Được làm việc trong một môi trường chuyên nghiệp và thân thiện;\nĐược tiếp cận hồ sơ dự án và giải quyết các công việc thực tế;\nCó cơ hội được trở thành tư vấn triển khai/kỹ thuật phần mềm Quản lý doanh nghiệp chính thức.\nĐược nhận lương theo chính sách thực tập sinh.',
    internshipDuration: 'Theo lịch của nhà trường từ thứ 2 đến thứ 6 hàng tuần',
    internshipPosition:
        '. Thực hiện các thủ tục công việc theo sự phân công của giám đốc và trưởng phòng ban;\n. Thực hiện các hoạt động khác theo sự phân công của giám đốc và trướng phòng ban.',
    address: 'Số 4 đường số 5 KDC Long Thịnh, Phú Thứ, Cái Răng Cần Thơ');
CompanyDetail companyDetailPRIMAES = CompanyDetail(
  applicationMethod:
      '- Send an application email to vltngan@drimaes.com\n- In the email, it should include:\n  - Your CV to show a short introduction about yourself, your interest and also share about how passionate you are in software development. It should also include some details about the projects you have done in/outside school\n  - Your GitHub profile link, the profile should contain source code of the projects you have done with, of course, it should be public so the interviewer can check through.\n  - Lastly, your scores table which includes your current GPA.\n- The email title should in the format of “Internship 2023 Application - [Position] - [Your Name]”',
  benefits:
      '- Young, active and modern environment\n- Involved in professional software development workflow\n- Opportunity to participate in real projects and promoted to official employee',
  internshipDuration: 'Theo lịch của nhà trường từ thứ 2 đến thứ 6 hàng tuần',
  internshipPosition:
      '- Mobile (Flutter): 2\n- Front-end (ReactJS): 2\n- Back-end (NodeJS): 2',
  address: 'TP Cần Thơ',
);
CompanyDetail companyDetailTMA = CompanyDetail(
  applicationMethod:
      '- Send an application email to vltngan@drimaes.com\n- In the email, it should include:\n  - Your CV to show a short introduction about yourself, your interest and also share about how passionate you are in software development. It should also include some details about the projects you have done in/outside school\n  - Your GitHub profile link, the profile should contain source code of the projects you have done with, of course, it should be public so the interviewer can check through.\n  - Lastly, your scores table which includes your current GPA.\n- The email title should in the format of “Internship 2023 Application - [Position] - [Your Name]”',
  benefits:
      '- Young, active and modern environment\n- Involved in professional software development workflow\n- Opportunity to participate in real projects and promoted to official employee',
  internshipDuration: 'Theo lịch của nhà trường từ thứ 2 đến thứ 6 hàng tuần',
  internshipPosition:
      '- Mobile (Flutter): 2\n- Front-end (ReactJS): 2\n- Back-end (NodeJS): 2',
  address: 'TP Cần Thơ',
);
