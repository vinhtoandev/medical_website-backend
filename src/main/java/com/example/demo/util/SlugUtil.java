package com.example.demo.util;

import org.springframework.stereotype.Component;

import java.text.Normalizer;
import java.util.regex.Pattern;

/**
 * Utility for generating URL-friendly slugs from Vietnamese text
 */
@Component
public class SlugUtil {

    private static final Pattern NONLATIN = Pattern.compile("[^\\w-]");
    private static final Pattern WHITESPACE = Pattern.compile("[\\s_-]+");

    /**
     * Generate URL-friendly slug from text
     * Converts Vietnamese characters and spaces to ASCII
     * Example: "Điều trị Mụn" -> "dieu-tri-mun"
     */
    public String generateSlug(String input) {
        if (input == null || input.isEmpty()) {
            return "";
        }

        // Convert to lowercase
        String result = input.toLowerCase().trim();

        // Remove accents and convert Vietnamese to ASCII
        result = removeAccents(result);

        // Replace whitespace and underscores with hyphens
        result = WHITESPACE.matcher(result).replaceAll("-");

        // Remove non-latin characters
        result = NONLATIN.matcher(result).replaceAll("");

        // Remove multiple consecutive hyphens
        result = result.replaceAll("-+", "-");

        // Remove leading and trailing hyphens
        result = result.replaceAll("^-|-$", "");

        return result;
    }

    /**
     * Remove accents from Vietnamese characters
     * Example: "á" -> "a", "ế" -> "e"
     */
    private String removeAccents(String input) {
        // Vietnamese character mappings
        String[][] vietnameseChars = {
                {"á", "a"}, {"à", "a"}, {"ả", "a"}, {"ã", "a"}, {"ạ", "a"},
                {"ă", "a"}, {"ắ", "a"}, {"ằ", "a"}, {"ẳ", "a"}, {"ẵ", "a"}, {"ặ", "a"},
                {"â", "a"}, {"ấ", "a"}, {"ầ", "a"}, {"ẩ", "a"}, {"ẫ", "a"}, {"ậ", "a"},
                {"é", "e"}, {"è", "e"}, {"ẻ", "e"}, {"ẽ", "e"}, {"ẹ", "e"},
                {"ê", "e"}, {"ế", "e"}, {"ề", "e"}, {"ể", "e"}, {"ễ", "e"}, {"ệ", "e"},
                {"í", "i"}, {"ì", "i"}, {"ỉ", "i"}, {"ĩ", "i"}, {"ị", "i"},
                {"ó", "o"}, {"ò", "o"}, {"ỏ", "o"}, {"õ", "o"}, {"ọ", "o"},
                {"ô", "o"}, {"ố", "o"}, {"ồ", "o"}, {"ổ", "o"}, {"ỗ", "o"}, {"ộ", "o"},
                {"ơ", "o"}, {"ớ", "o"}, {"ờ", "o"}, {"ở", "o"}, {"ỡ", "o"}, {"ợ", "o"},
                {"ú", "u"}, {"ù", "u"}, {"ủ", "u"}, {"ũ", "u"}, {"ụ", "u"},
                {"ư", "u"}, {"ứ", "u"}, {"ừ", "u"}, {"ử", "u"}, {"ữ", "u"}, {"ự", "u"},
                {"ý", "y"}, {"ỳ", "y"}, {"ỷ", "y"}, {"ỹ", "y"}, {"ỵ", "y"},
                {"đ", "d"}
        };

        String result = input;
        for (String[] pair : vietnameseChars) {
            result = result.replace(pair[0], pair[1]);
            result = result.replace(pair[0].toUpperCase(), pair[1]);
        }

        // Also handle standard accents using Unicode normalization
        String normalized = Normalizer.normalize(result, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        result = pattern.matcher(normalized).replaceAll("");

        return result;
    }
}
