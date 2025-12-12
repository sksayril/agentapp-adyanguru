class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final AgentData? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? AgentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AgentData {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final bool? isActive;
  final String? lastLogin;
  final String? token;

  AgentData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isActive,
    this.lastLogin,
    this.token,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) {
    return AgentData(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      isActive: json['isActive'],
      lastLogin: json['lastLogin'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'lastLogin': lastLogin,
      'token': token,
    };
  }
}

class AgentProfile {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? agentCode;
  final String? role;
  final bool? isActive;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;
  final Area? area;
  final String? image;
  final SuperAgent? superAgentId;
  final String? superAgentName;
  final int? assignedTarget;
  final int? achievedTarget;

  AgentProfile({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.agentCode,
    this.role,
    this.isActive,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.area,
    this.image,
    this.superAgentId,
    this.superAgentName,
    this.assignedTarget,
    this.achievedTarget,
  });

  factory AgentProfile.fromJson(Map<String, dynamic> json) {
    return AgentProfile(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      agentCode: json['agentCode']?.toString(),
      role: json['role']?.toString(),
      isActive: json['isActive'] as bool?,
      lastLogin: json['lastLogin']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      area: json['area'] != null && json['area'] is Map<String, dynamic>
          ? Area.fromJson(json['area'] as Map<String, dynamic>)
          : null,
      image: json['image']?.toString(),
      superAgentId: json['superAgentId'] != null && json['superAgentId'] is Map<String, dynamic>
          ? SuperAgent.fromJson(json['superAgentId'] as Map<String, dynamic>)
          : null,
      superAgentName: json['superAgentName']?.toString(),
      assignedTarget: json['assignedTarget'] is int ? json['assignedTarget'] as int : (json['assignedTarget'] is num ? (json['assignedTarget'] as num).toInt() : null),
      achievedTarget: json['achievedTarget'] is int ? json['achievedTarget'] as int : (json['achievedTarget'] is num ? (json['achievedTarget'] as num).toInt() : null),
    );
  }
}

class Area {
  final String? areaname;
  final String? city;
  final String? pincode;
  final Coordinates? coordinates;

  Area({
    this.areaname,
    this.city,
    this.pincode,
    this.coordinates,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaname: json['areaname']?.toString(),
      city: json['city']?.toString(),
      pincode: json['pincode']?.toString(),
      coordinates: json['coordinates'] != null && json['coordinates'] is Map<String, dynamic>
          ? Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

class SuperAgent {
  final String? id;
  final String? name;
  final String? email;
  final String? agentCode;

  SuperAgent({
    this.id,
    this.name,
    this.email,
    this.agentCode,
  });

  factory SuperAgent.fromJson(Map<String, dynamic> json) {
    return SuperAgent(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      agentCode: json['agentCode'],
    );
  }
}

class AgentCodeResponse {
  final bool success;
  final String message;
  final AgentCodeData? data;

  AgentCodeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AgentCodeResponse.fromJson(Map<String, dynamic> json) {
    return AgentCodeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AgentCodeData.fromJson(json['data']) : null,
    );
  }
}

class AgentCodeData {
  final String? agentCode;
  final String? name;
  final String? shareUrl;

  AgentCodeData({
    this.agentCode,
    this.name,
    this.shareUrl,
  });

  factory AgentCodeData.fromJson(Map<String, dynamic> json) {
    return AgentCodeData(
      agentCode: json['agentCode'],
      name: json['name'],
      shareUrl: json['shareUrl'],
    );
  }
}

class WalletBalance {
  final double? balance;
  final double? totalEarned;
  final double? pendingWithdrawal;
  final double? availableBalance;
  final String? currency;
  final String? lastTransactionAt;

  WalletBalance({
    this.balance,
    this.totalEarned,
    this.pendingWithdrawal,
    this.availableBalance,
    this.currency,
    this.lastTransactionAt,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      balance: json['balance'] is num ? (json['balance'] as num).toDouble() : 0.0,
      totalEarned: json['totalEarned'] is num ? (json['totalEarned'] as num).toDouble() : 0.0,
      pendingWithdrawal: json['pendingWithdrawal'] is num ? (json['pendingWithdrawal'] as num).toDouble() : 0.0,
      availableBalance: json['availableBalance'] is num ? (json['availableBalance'] as num).toDouble() : 0.0,
      currency: json['currency']?.toString() ?? 'INR',
      lastTransactionAt: json['lastTransactionAt']?.toString(),
    );
  }
}

class WalletDetails {
  final double? balance;
  final double? totalEarned;
  final double? pendingWithdrawal;
  final double? availableBalance;
  final String? currency;

  WalletDetails({
    this.balance,
    this.totalEarned,
    this.pendingWithdrawal,
    this.availableBalance,
    this.currency,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      balance: json['balance'] is num ? (json['balance'] as num).toDouble() : 0.0,
      totalEarned: json['totalEarned'] is num ? (json['totalEarned'] as num).toDouble() : 0.0,
      pendingWithdrawal: json['pendingWithdrawal'] is num ? (json['pendingWithdrawal'] as num).toDouble() : 0.0,
      availableBalance: json['availableBalance'] is num ? (json['availableBalance'] as num).toDouble() : 0.0,
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

class StudentsResponse {
  final bool success;
  final String message;
  final StudentsData? data;

  StudentsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    return StudentsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? StudentsData.fromJson(json['data']) : null,
    );
  }
}

class StudentsData {
  final List<Student>? items;
  final Pagination? pagination;

  StudentsData({this.items, this.pagination});

  factory StudentsData.fromJson(Map<String, dynamic> json) {
    return StudentsData(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Student.fromJson(e)).toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Student {
  final String? id;
  final String? name;
  final String? email;
  final String? studentId;
  final String? contactNumber;
  final String? createdAt;

  Student({
    this.id,
    this.name,
    this.email,
    this.studentId,
    this.contactNumber,
    this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
      contactNumber: json['contactNumber'],
      createdAt: json['createdAt'],
    );
  }
}

class CommissionsResponse {
  final bool success;
  final String message;
  final CommissionsData? data;

  CommissionsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CommissionsResponse.fromJson(Map<String, dynamic> json) {
    return CommissionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CommissionsData.fromJson(json['data']) : null,
    );
  }
}

class CommissionsData {
  final List<Commission>? items;
  final Pagination? pagination;

  CommissionsData({this.items, this.pagination});

  factory CommissionsData.fromJson(Map<String, dynamic> json) {
    return CommissionsData(
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Commission.fromJson(e)).toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Commission {
  final String? id;
  final double? amount;
  final String? status;
  final String? createdAt;
  final StudentInfo? student;
  final String? transactionId;

  Commission({
    this.id,
    this.amount,
    this.status,
    this.createdAt,
    this.student,
    this.transactionId,
  });

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      id: json['id'] ?? json['_id'],
      amount: json['amount']?.toDouble() ?? 0.0,
      status: json['status'],
      createdAt: json['createdAt'],
      student: json['student'] != null
          ? StudentInfo.fromJson(json['student'])
          : null,
      transactionId: json['transactionId'],
    );
  }
}

class StudentInfo {
  final String? name;
  final String? email;
  final String? studentId;

  StudentInfo({this.name, this.email, this.studentId});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'],
      email: json['email'],
      studentId: json['studentId'],
    );
  }
}

class Pagination {
  final int? page;
  final int? limit;
  final int? total;
  final int? pages;

  Pagination({this.page, this.limit, this.total, this.pages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }
}

class StudentSignupAnalytics {
  final AgentInfo? agent;
  final bool? includeSubagents;
  final List<SubAgent>? subagents;
  final Period? period;
  final PeriodData? currentPeriod;
  final PeriodData? previousPeriod;
  final Growth? growth;
  final List<MonthlyBreakdown>? monthlyBreakdown;
  final Summary? summary;

  StudentSignupAnalytics({
    this.agent,
    this.includeSubagents,
    this.subagents,
    this.period,
    this.currentPeriod,
    this.previousPeriod,
    this.growth,
    this.monthlyBreakdown,
    this.summary,
  });

  factory StudentSignupAnalytics.fromJson(Map<String, dynamic> json) {
    return StudentSignupAnalytics(
      agent: json['agent'] != null ? AgentInfo.fromJson(json['agent']) : null,
      includeSubagents: json['includeSubagents'],
      subagents: json['subagents'] != null
          ? (json['subagents'] as List)
              .map((e) => SubAgent.fromJson(e))
              .toList()
          : [],
      period: json['period'] != null ? Period.fromJson(json['period']) : null,
      currentPeriod: json['currentPeriod'] != null
          ? PeriodData.fromJson(json['currentPeriod'])
          : null,
      previousPeriod: json['previousPeriod'] != null
          ? PeriodData.fromJson(json['previousPeriod'])
          : null,
      growth: json['growth'] != null ? Growth.fromJson(json['growth']) : null,
      monthlyBreakdown: json['monthlyBreakdown'] != null
          ? (json['monthlyBreakdown'] as List)
              .map((e) => MonthlyBreakdown.fromJson(e))
              .toList()
          : [],
      summary: json['summary'] != null ? Summary.fromJson(json['summary']) : null,
    );
  }
}

class AgentInfo {
  final String? id;
  final String? name;
  final String? email;

  AgentInfo({this.id, this.name, this.email});

  factory AgentInfo.fromJson(Map<String, dynamic> json) {
    return AgentInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class SubAgent {
  final String? id;
  final String? name;
  final String? email;

  SubAgent({this.id, this.name, this.email});

  factory SubAgent.fromJson(Map<String, dynamic> json) {
    return SubAgent(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class Period {
  final String? start;
  final String? end;
  final String? label;

  Period({this.start, this.end, this.label});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      start: json['start'],
      end: json['end'],
      label: json['label'],
    );
  }
}

class PeriodData {
  final int? signups;
  final String? start;
  final String? end;

  PeriodData({this.signups, this.start, this.end});

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      signups: json['signups'],
      start: json['start'],
      end: json['end'],
    );
  }
}

class Growth {
  final GrowthData? monthOverMonth;
  final GrowthData? yearOverYear;

  Growth({this.monthOverMonth, this.yearOverYear});

  factory Growth.fromJson(Map<String, dynamic> json) {
    return Growth(
      monthOverMonth: json['monthOverMonth'] != null
          ? GrowthData.fromJson(json['monthOverMonth'])
          : null,
      yearOverYear: json['yearOverYear'] != null
          ? GrowthData.fromJson(json['yearOverYear'])
          : null,
    );
  }
}

class GrowthData {
  final double? percentage;
  final int? change;
  final String? direction;

  GrowthData({this.percentage, this.change, this.direction});

  factory GrowthData.fromJson(Map<String, dynamic> json) {
    return GrowthData(
      percentage: json['percentage']?.toDouble(),
      change: json['change'],
      direction: json['direction'],
    );
  }
}

class MonthlyBreakdown {
  final String? month;
  final String? monthName;
  final int? count;

  MonthlyBreakdown({this.month, this.monthName, this.count});

  factory MonthlyBreakdown.fromJson(Map<String, dynamic> json) {
    return MonthlyBreakdown(
      month: json['month'],
      monthName: json['monthName'],
      count: json['count'],
    );
  }
}

class Summary {
  final int? totalCurrentPeriod;
  final int? totalPreviousPeriod;
  final int? totalPreviousYear;
  final String? averagePerMonth;

  Summary({
    this.totalCurrentPeriod,
    this.totalPreviousPeriod,
    this.totalPreviousYear,
    this.averagePerMonth,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalCurrentPeriod: json['totalCurrentPeriod'],
      totalPreviousPeriod: json['totalPreviousPeriod'],
      totalPreviousYear: json['totalPreviousYear'],
      averagePerMonth: json['averagePerMonth'],
    );
  }
}

class DetailedStudentSignupsResponse {
  final bool success;
  final String message;
  final List<DetailedStudent>? data;
  final Pagination? pagination;
  final Filters? filters;

  DetailedStudentSignupsResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    this.filters,
  });

  factory DetailedStudentSignupsResponse.fromJson(Map<String, dynamic> json) {
    return DetailedStudentSignupsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => DetailedStudent.fromJson(e))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      filters: json['filters'] != null ? Filters.fromJson(json['filters']) : null,
    );
  }
}

class DetailedStudent {
  final String? id;
  final String? name;
  final String? email;
  final String? contactNumber;
  final String? createdAt;
  final AgentInfo? agentId;

  DetailedStudent({
    this.id,
    this.name,
    this.email,
    this.contactNumber,
    this.createdAt,
    this.agentId,
  });

  factory DetailedStudent.fromJson(Map<String, dynamic> json) {
    return DetailedStudent(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      createdAt: json['createdAt'],
      agentId: json['agentId'] != null ? AgentInfo.fromJson(json['agentId']) : null,
    );
  }
}

class Filters {
  final bool? includeSubagents;
  final String? startDate;
  final String? endDate;

  Filters({this.includeSubagents, this.startDate, this.endDate});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      includeSubagents: json['includeSubagents'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}

class WalletTransactionsResponse {
  final bool success;
  final String message;
  final List<WalletTransaction>? data;
  final Pagination? pagination;

  WalletTransactionsResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
  });

  factory WalletTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => WalletTransaction.fromJson(e))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class WalletTransaction {
  final String? id;
  final String? agentId;
  final String? type;
  final double? amount;
  final String? status;
  final String? category;
  final double? balanceBefore;
  final double? balanceAfter;
  final String? transactionReference;
  final String? createdAt;

  WalletTransaction({
    this.id,
    this.agentId,
    this.type,
    this.amount,
    this.status,
    this.category,
    this.balanceBefore,
    this.balanceAfter,
    this.transactionReference,
    this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['_id'] ?? json['id'],
      agentId: json['agentId'],
      type: json['type'],
      amount: json['amount']?.toDouble() ?? 0.0,
      status: json['status'],
      category: json['category'],
      balanceBefore: json['balanceBefore']?.toDouble() ?? 0.0,
      balanceAfter: json['balanceAfter']?.toDouble() ?? 0.0,
      transactionReference: json['transactionReference'],
      createdAt: json['createdAt'],
    );
  }
}

