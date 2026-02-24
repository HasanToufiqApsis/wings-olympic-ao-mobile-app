import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/constant_variables.dart';
import '../../../constants/language_global.dart';
import '../../../provider/global_provider.dart';
import '../../../reusable_widgets/language_textbox.dart';
import '../../../services/shared_storage_services.dart';

class LanguageChangeButton extends StatelessWidget {
  const LanguageChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        String lang = ref.watch(languageProvider);
        return Container(
          width: MediaQuery.of(context).size.width / 3.4,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: .35),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: DropdownButton<String>(
            value: lang,
            isExpanded: true,
            dropdownColor: primary,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (String? newValue) async {
              ref.read(languageProvider.notifier).state = newValue!;
              await LocalStorageHelper.save('lang', newValue);
            },
            items: availableLanguages.map<DropdownMenuItem<String>>(
                  (value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      LangText(
                        value == 'en' ? 'English' : value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ), // বাংলা
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
